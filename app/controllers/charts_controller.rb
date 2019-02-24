include ActionView::Helpers::TagHelper
include ActionView::Context
include ActionView::Helpers::TranslationHelper
include ActionView::Helpers::JavaScriptHelper
include ActionView::Helpers::AssetTagHelper
require_relative '../functions'
require 'json'
require 'bigdecimal'

class ChartsController < ApplicationController

  @sizeX = '10000'
  @sizeY = '200'

  def show

    calc_profit_chart()
    calc_ban_time_chart()
    calc_schema_profitability_chart()

    render 'charts'
  end

  def calc_profit_chart
    timezone_offset = Time.zone.formatted_offset
    interval = "#{timezone_offset[0]} time '#{timezone_offset[1..-1]}'"
    start_date = 60.days.ago
    @recent_profits_rows = MuleLog.where('created_at IS NOT NULL')
                               .where('created_at > ?', start_date.beginning_of_day)
                               .group("DATE(created_at #{interval})", config.time_zone)
                               .select("date(created_at #{interval}) as date, SUM(item_amount) AS money_made")
                               .order("date").all
    @accounts_created_rows = Account.where('created_at IS NOT NULL')
                                 .where('created=true')
                                 .where('created_at > ?', start_date.beginning_of_day)
                                 .group("DATE(created_at #{interval})", config.time_zone)
                                 .select("date(created_at #{interval}) as date, COUNT(*) AS count")
                                 .order("date").all
    @accounts_banned_rows = Account.where('last_seen IS NOT NULL')
                                .where('last_seen > ?', start_date.beginning_of_day)
                                .where('created=true AND banned=true')
                                .group("DATE(last_seen #{interval})", config.time_zone)
                                .select("date(last_seen #{interval}) as date, COUNT(*) AS count")
                                .order("date").all

    @dates = []
    @recent_profits = []
    @accounts_created = []
    @accounts_banned = []
    @recent_profits_rows.each do |pr|
      date = pr.date
      @dates << date
      @recent_profits << (pr.money_made / 1000000).round(1)

      row = @accounts_created_rows.select { |row| row.date == date}.first
      @accounts_created << (row.nil? ? 0 : row.count)

      row = @accounts_banned_rows.select { |row| row.date == date}.first
      @accounts_banned << (row.nil? ? 0 : row.count)
    end

    data = {
        labels: @dates,
        datasets: [
            {
                label: "Mil/GP made",
                backgroundColor: "rgba(255, 199, 58,0.01)",
                borderColor: "rgba(255, 199, 58,1)",
                data: @recent_profits
            },
            {
                label: "Accounts Created",
                backgroundColor: "rgba(37, 209, 54,0.01)",
                borderColor: "rgba(37, 209, 54,1)",
                data: @accounts_created
            },
            {
                label: "Accounts Banned",
                backgroundColor: "rgba(216, 32, 32,0.01)",
                borderColor: "rgba(216, 32, 32,1)",
                data: @accounts_banned
            }
        ]
    }
    options = { width: @sizeX, height: @sizeY }

    @profit_chart = ChartHelpers.chart('line', data, options);
  end
  def calc_ban_time_chart
    timezone_offset = Time.zone.formatted_offset
    interval = "#{timezone_offset[0]} time '#{timezone_offset[1..-1]}'"
    start_date = 60.days.ago
    @ban_time_rows = Account.where('last_seen IS NOT NULL')
                     .where('last_seen > ?', start_date.beginning_of_day)
                     .where('created=true AND banned=true')
                     .group("extract(hour from (last_seen #{interval}))", config.time_zone)
                     .select("extract(hour from (last_seen #{interval})) as hour, COUNT(*) AS count")
                     .order("hour").all

    @bans_by_hour = Array.new(24, 0)
    @hours_of_the_day = [24]
    24.times do |i|
      @hours_of_the_day[i] = "#{i}H"
    end
    @ban_time_rows.each do |row|
      hour = row.hour.round
      @bans_by_hour[hour] = row.count
    end

    data = {
        labels: @hours_of_the_day,
        datasets: [
            {
                label: "Total Bans",
                backgroundColor: "rgba(255, 199, 58,0.01)",
                borderColor: "rgba(255, 199, 58,1)",
                data: @bans_by_hour
            },
        ]
    }
    options = { width: @sizeX, height: @sizeY }

    @ban_time_chart = ChartHelpers.chart('line', data, options);
  end
  def calc_schema_profitability_chart

    # interval = "#{timezone_offset[0]} time '#{timezone_offset[1..-1]}'"
    start_date = 5.days.ago
    @accounts = Account.where('last_seen IS NOT NULL')
                          .where('last_seen > ?', start_date.beginning_of_day)
                         .where('last_seen > created_at')
                         .where('created=true AND banned=true')
                         .order('id DESC')
                         .limit(100)
                    .all
                    .includes(:mule_logs)

    all_schema_data = Array.new
    @accounts.each do |account|
      next if account.schema == nil
      next if account.account_type.name.include? "MULE"
      bannedAt = ((account.last_seen - account.created_at) / 3_600).floor
      schema_id = 0 #account.schema.original_id
      schema_data = all_schema_data[schema_id]
      if schema_data == nil
        schema_data = all_schema_data[schema_id] = SchemaProfit.new("RSPeer")#account.schema.name)
      end
      hourly_profit = Array.new
      account.mule_logs.each do |mule_log|
        hour_of_operation = ((mule_log.created_at - account.created_at) / 3_600).floor
        hourly_profit[hour_of_operation] = hourly_profit[hour_of_operation].to_i + mule_log.item_amount
      end
      # bannedAt.times do |i|
      #   profit = hourly_profit[i]
      #   profit = 0 if profit.nil?
      #   schema_data.addProfitForHour(i, profit)
      # end
      hourly_profit.each_with_index do |val,index|
        val = 0 if val.nil?
        break if index > bannedAt
        break if index >= bannedAt && val = 0
        schema_data.addProfitForHour(index, val)
      end
    end

    r = Random.new
    datasets = []
    all_schema_data.each do |schema_data|
      datasets << {
          label: schema_data.name,
          backgroundColor: "rgba(0, 0, 0, 0)",
          borderColor: "rgba(#{r.rand(255)}, #{r.rand(255)}, #{r.rand(255)},1)",
          data: schema_data.getHourlyData
      }
    end

    @all_schema_data = all_schema_data[0].getRaw

    data = {
        labels: @hours_of_the_day,
        datasets: datasets
    }
    options = { width: @sizeX, height: @sizeY }

    @schema_profitability_chart = ChartHelpers.chart('line', data, options);
  end
end
class SchemaProfit
  @name = ""
  def name
    return @name
  end
  def getRaw
    return @dataPairs
  end
  def initialize(name)
    @dataPairs = Array.new(32, nil )
    @name = name
  end
  public def addProfitForHour(hour, profit)
    if @dataPairs[hour] == nil
      @dataPairs[hour] = { :samples => 0, :profit => 0}
    end
    @dataPairs[hour][:samples] += 1
    @dataPairs[hour][:profit] += profit
  end
  public def getHourlyData
    newData = Array.new(32, 0)
    @dataPairs.each_with_index do |val, index|
      val = { :samples => 0, :profit => 0} if val.nil?
      samples = val[:samples]
      samples = 1 if samples < 1
      newData[index] = val[:profit] / samples
    end
    return newData
  end
end

module ChartHelpers
  CHART_TYPES = %w[ bar bubble doughnut horizontal_bar line pie polar_area radar scatter ]

  def self.chart(type, data, options)
    opts = options.dup

    @chart_id ||= -1
    element_id = opts.delete(:id)     || "chart-#{@chart_id += 1}"
    css_class  = opts.delete(:class)  || 'chart'
    width      = opts.delete(:width)  || '100'
    height     = opts.delete(:height) || '40'

    canvas = content_tag :canvas, '', id: element_id, class: css_class, width: width, height: height

    script = javascript_tag() do
      <<-END.squish.html_safe
      (function() {
        var initChart = function() {
          var ctx = document.getElementById(#{element_id.to_json});
          var chart = new Chart(ctx, {
            type:    "#{camel_case type}",
            data:    #{to_javascript_string data},
            options: #{to_javascript_string opts}
          });
        };
        if (typeof Chart !== "undefined" && Chart !== null) {
          initChart();
        }
        else {
          /* W3C standard */
          if (window.addEventListener) {
            window.addEventListener("load", initChart, false);
          }
          /* IE */
          else if (window.attachEvent) {
            window.attachEvent("onload", initChart);
          }
        }
      })();
      END
    end

    canvas + script
  end

  # polar_area -> polarArea
  def self.camel_case(string)
    string.gsub(/_([a-z])/) { $1.upcase }
  end

  def self.to_javascript_string(element)
    case element
    when Hash
      hash_elements = []
      element.each do |key, value|
        hash_elements << camel_case(key.to_s).to_json + ':' + to_javascript_string(value)
      end
      '{' + hash_elements.join(',') + '}'
    when Array
      array_elements = []
      element.each do |value|
        array_elements << to_javascript_string(value)
      end
      '[' + array_elements.join(',') + ']'
    when String
      if element.match(/^\s*function.*}\s*$/m)
        # Raw-copy function definitions to the output without surrounding quotes.
        element
      else
        element.to_json
      end
    when BigDecimal
      element.to_s
    else
      element.to_json
    end
  end

end
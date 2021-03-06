include ActionView::Helpers::TagHelper
include ActionView::Context
include ActionView::Helpers::TranslationHelper
include ActionView::Helpers::JavaScriptHelper
include ActionView::Helpers::AssetTagHelper
require_relative '../functions'
require 'json'
require 'bigdecimal'

class ChartsController < ApplicationController

  def get_master_mule_account_type
    return AccountType.where(:name => "MASTER_MULE").first
  end
  def get_mule_account_type
    return AccountType.where(:name => "MULE").first
  end
  def get_master_mules
    account_type = get_master_mule_account_type
    return Account.where(account_type_id: account_type.id, banned: false, created: true).all
  end
  def get_mules
    account_type = get_mule_account_type
    return Account.where(account_type_id: account_type.id, banned: false, created: true).all
  end
  # def is_master_mule_log (log)
  #   @master_mules = get_master_mules if @master_mules == nil
  #   if @master_mules.size > 0
  #     # return true if @master_mules.any? {|mm| mm.id == log.account_id }
  #     return true if @master_mules.any? {|mm| mm.username.casecmp(log.mule) == 0 }
  #   end
  #   return false
  # end


  def show

    @chartColors = {
        red: 'rgb(255, 99, 132)',
        orange: 'rgb(255, 159, 64)',
        yellow: 'rgb(255, 205, 86)',
        green: 'rgb(75, 192, 192)',
        blue: 'rgb(54, 162, 235)',
        purple: 'rgb(153, 102, 255)',
        grey: 'rgb(201, 203, 207)'
    }

    @timezone_offset = Time.zone_offset(Time.now.getlocal.zone) / 3600
    @tz_interval = (@timezone_offset >= 0 ? "+" : "-") + " interval '#{@timezone_offset} hour'"

    # render plain: @timezone_offset
    # return
    @mules = get_mules.to_a
    @mules_ids = @mules.pluck(:id)
    @master_mules = get_master_mules.to_a
    @master_mule_ids = @master_mules.pluck(:id)
    @master_mule_names = @master_mules.pluck(:username)
    @master_mule_names = @master_mule_names.map(&:downcase)

    @chart_options = { style: 'max-width:900px; min-height: 400px', responsive: false, maintainAspectRatio: false,
                      pan: {
                        enabled: true,
                        mode: 'x'
                      },
                       zoom: {
                        enabled: true,
                        mode: 'x',
                       }
    }

    @profit_chart = calc_profit_chart()
    @hourly_profit_chart = calc_hourly_profit_chart()
    @ban_time_chart = calc_ban_time_chart()
    @schema_profitability_chart = calc_schema_profitability_chart()
    @account_creation_rates = calc_account_creation_rates()

    render 'charts'
  end

  def calc_profit_chart
    interval = @tz_interval
    start_date = 60.days.ago



    @recent_profits_rows = MuleLog.where('created_at IS NOT NULL')
                               .where('created_at > ?', start_date.beginning_of_day)
                               .where.not(account_id: @mules_ids)
                               .where.not(account_id: @master_mule_ids, mule: @master_mule_names)
                               .group("DATE(created_at #{interval})", config.time_zone)
                               .select("date(created_at #{interval}) as date, SUM(item_amount) AS money_made")
                               .order("date").all
    @recent_expenses_rows = MuleLog.where('created_at IS NOT NULL')
                               .where('created_at > ?', start_date.beginning_of_day)
                               .where(account_id: @mules_ids)
                               .where.not(account_id: @master_mule_ids, mule: @master_mule_names)
                               .group("DATE(created_at #{interval})", config.time_zone)
                               .select("date(created_at #{interval}) as date, SUM(item_amount) AS money_made")
                               .order("date").all.to_a
    @accounts_created_rows = Account.where('created_at IS NOT NULL')
                                 .where('time_online > 500')
                                 .where('created_at > ?', start_date.beginning_of_day)
                                 .group("DATE(created_at #{interval})", config.time_zone)
                                 .select("date(created_at #{interval}) as date, COUNT(*) AS count")
                                 .order("date").all
    @accounts_banned_rows = Account.where('last_seen IS NOT NULL')
                                .where('last_seen > ?', start_date.beginning_of_day)
                                .where('time_online > 500 AND banned=true')
                                .group("DATE(last_seen #{interval})", config.time_zone)
                                .select("date(last_seen #{interval}) as date, COUNT(*) AS count")
                                .order("date").all

    @dates = []
    @recent_profits = []
    @accounts_created = []
    @accounts_banned = []
    @recent_profits_rows.each do |pr|
      # next if is_master_mule_log(pr)
      date = pr.date
      @dates << date
      expenses = @recent_expenses_rows.select{ |row| row.date == date }.first
      expense = expenses == nil ? 0 : expenses.money_made
      @recent_profits << ((pr.money_made - expense) / 1000000).round(1)

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

    return ChartHelpers.chart('line', data, @chart_options);
  end
  def calc_hourly_profit_chart
    interval = @tz_interval
    start_date = 7.days.ago
    recent_expense_rows = MuleLog.where('created_at IS NOT NULL')
                               .where('created_at > ?', start_date.beginning_of_day)
                              .where(account_id: @mules_ids)
                              .where.not(account_id: @master_mule_ids, mule: @master_mule_names)
                               .select("date_trunc('hour', (created_at #{interval})) as hour, SUM(item_amount) AS money_made")
                               .group("hour")
                               .order("hour").all
    recent_profits_rows = MuleLog.where('created_at IS NOT NULL')
                               .where('created_at > ?', start_date.beginning_of_day)
                               .where.not(account_id: @mules_ids)
                              .where.not(account_id: @master_mule_ids, mule: @master_mule_names)
                               .select("date_trunc('hour', (created_at #{interval})) as hour, SUM(item_amount) AS money_made")
                               .group("hour")
                               .order("hour").all

    dates = []
    recent_profits = Array.new
    recent_expenses = Array.new
    if recent_profits_rows.first == nil
      earliest_date = DateTime.now
    else
      earliest_date = recent_profits_rows.first.hour
    end
    earliest_date = recent_expense_rows.first.hour if recent_expense_rows.first != nil && recent_expense_rows.first.hour < earliest_date
    last_date = earliest_date;
    recent_profits_rows.each do |pr|
      # next if is_master_mule_log(pr)
      while pr.hour - last_date > 60.minutes
        last_date = last_date + 60.minutes
        date = ("#{last_date}".sub!(":00:00 UTC", ""))
        dates << date
        recent_profits << 0
      end
      last_date = pr.hour
      date = "#{pr.hour}".sub!(":00:00 UTC", "")
      dates << date
      recent_profits << pr.money_made.to_i
    end
    last_date = earliest_date
    recent_expense_rows.each do |pr|
      # next if is_master_mule_log(pr)
      while pr.hour - last_date > 60.minutes
        last_date = last_date + 60.minutes
        recent_expenses << 0
      end
      last_date = pr.hour
      # date = "#{pr.hour}".sub!(":00:00 UTC", "")
      recent_expenses << pr.money_made.to_i
    end

    data = {
        labels: dates,
        datasets: [
            {
                label: "GP made",
                backgroundColor: "rgba(255, 187, 0,0.01)",
                borderColor: "rgba(255, 187, 0,1)",
                data: recent_profits
            },
            {
              label: "Expenses",
              backgroundColor: "rgba(255, 0, 0,0.01)",
              borderColor: "rgba(255, 0, 0,1)",
              data: recent_expenses
            },
        ],
    }
    options = { scales: {
        xAxes: [{
            ticks: {
                min: 0
            }}]}}
    options = options.merge(@chart_options)

    return ChartHelpers.chart('line', data, options);
  end
  def calc_ban_time_chart

    interval = @tz_interval
    start_date = 60.days.ago
    @ban_time_rows = Account.where('last_seen IS NOT NULL')
                     .where('last_seen > ?', start_date.beginning_of_day)
                     .where('created=true AND banned=true')
                     .group("extract(hour from (last_seen #{interval}))", config.time_zone)
                     .select("extract(hour from (last_seen #{interval})) as hour, COUNT(*) AS count")
                     .order("hour").all

    @bans_by_hour = Array.new(24, 0)
    hours_of_the_day = [24]
    24.times do |i|
      hours_of_the_day[i] = "#{i}H"
    end
    @ban_time_rows.each do |row|
      hour = row.hour.round
      hour -= 24 if hour >= 24
      hour += 24 if hour < 0
      @bans_by_hour[hour] = row.count
    end

    data = {
        labels: hours_of_the_day,
        datasets: [
            {
                label: "Total Bans",
                backgroundColor: "rgba(0, 0, 0,0.01)",
                borderColor: "rgba(0, 0, 0,1)",
                data: @bans_by_hour
            },
        ]
    }

    return ChartHelpers.chart('line', data, @chart_options);
  end
  def calc_schema_profitability_chart

    # interval = "#{timezone_offset[0]} time '#{timezone_offset[1..-1]}'"
    start_date = 5.days.ago
    accounts = Account.includes(:mule_logs, :schema, :account_type).where('last_seen IS NOT NULL')
                          .where('last_seen > ?', start_date.beginning_of_day)
                         .where('last_seen > created_at AND time_online > 7200')
                         .where('created=true AND banned=true')
                         .order('id DESC')
                         .limit(100)
                          .all

    original_schema_ids = accounts.map { |acc| acc.schema.original_id }.uniq
    original_schemas = Schema.where(id: original_schema_ids).to_a

    max_hour = 24
    all_schema_data = {}
    accounts.each do |account|
      next if account.schema == nil
      next if account.account_type.name.include? "MULE"
      bannedAt = ((account.last_seen - account.created_at) / 3_600).floor
      hours_online = (account.time_online / 3_600).floor
      next if bannedAt - hours_online > 4 # if the account has been offline for a significant time, exclude
      schema_id = account.schema.original_id
      original_schema = original_schemas.select{|s|s.id == schema_id}.first
      schema_name = (original_schema != nil ? original_schema.name : account.schema.name)
      schema_data = all_schema_data[schema_name]
      if schema_data == nil
        schema_data = all_schema_data[schema_name] = SchemaProfit.new(schema_name)#account.schema.name)
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
      hourly_profit.each_with_index do |val,hour|
        val = 0 if val.nil?
        break if hour > bannedAt
        break if hour >= bannedAt && val = 0
        max_hour = hour if hour > max_hour
        schema_data.addProfitForHour(hour, val)
      end
    end

    r = Random.new
    datasets = []
    all_schema_data.each_value do |schema_data|
      datasets << {
          label: schema_data.name,
          backgroundColor: "rgba(0, 0, 0, 0)",
          borderColor: "rgba(#{r.rand(255)}, #{r.rand(255)}, #{r.rand(255)},1)",
          data: schema_data.getHourlyData
      }
    end

    labels = Array.new([max_hour,48].min)
    labels.size.times do |i|
      labels[i] = "#{i}H"
    end

    # all_schema_data = all_schema_data[0].getRaw

    data = {
        labels: labels,
        datasets: datasets
    }

    return ChartHelpers.chart('line', data, @chart_options);
  end
end
class SchemaProfit
  @name = ""
  public def name
    return @name
  end
  public def getRaw
    return @dataPairs
  end
  public def initialize(name)
    @dataPairs = Array.new(24, nil )
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
    newData = Array.new(24, 0)
    @dataPairs.each_with_index do |val, index|
      val = { :samples => 0, :profit => 0} if val.nil?
      samples = val[:samples]
      samples = 1 if samples < 1
      newData[index] = val[:profit] / samples
    end
    return newData
  end
end


def calc_account_creation_rates
  interval = @tz_interval
  start_date = 60.days.ago
  accounts_created_rows = Account.where('created_at IS NOT NULL')
                               .where('time_online > 0')
                               .where('created_at > ?', start_date.beginning_of_day)
                               .group("proxy_id,DATE(created_at #{interval})", config.time_zone)
                               .select("proxy_id, date(created_at #{interval}) as date, COUNT(*) AS count")
                               .order("date").all
  accounts_not_created_rows = Account.where('created_at IS NOT NULL')
                              .where('created = false')
                              .where('created_at > ?', start_date.beginning_of_day)
                              .group("proxy_id, DATE(created_at #{interval})", config.time_zone)
                              .select("proxy_id, date(created_at #{interval}) as date, COUNT(*) AS count")
                              .order("date").all

  all_proxies = Proxy.all
  dates = []
  accounts_created = {}
  accounts_not_created = {}
  accounts_created_rows.each do |row|
    date = row.date
    dates << date if(dates.length == 0 || date > dates.last)
    proxy = all_proxies.select{|r| r.id == row.proxy_id }.first
    proxy_name = nil
    proxy_name = proxy.location.to_s if proxy != nil
    proxy_name = "[DELETED]" if proxy_name == nil

    accounts_created[proxy_name] = Array.new(dates.length - 1, 0) if accounts_created[proxy_name].nil?
    accounts_not_created[proxy_name] = Array.new(dates.length - 1, 0) if accounts_not_created[proxy_name].nil?

    row2 = accounts_not_created_rows.select { |row2| row2.date == date && row2.proxy_id == row.proxy_id}.first

    accounts_created[proxy_name] << (row.nil? ? 0 : row.count)
    accounts_not_created[proxy_name] << (row2.nil? ? 0 : row2.count)
  end
  @accounts_created_rows = accounts_created

  data = {
      labels: dates,
      datasets: [
      ]
  }
  accounts_created.each do |proxy_name, array|
    data[:datasets] << {
        label: "#{proxy_name} Created",
        backgroundColor: "rgba(37, 209, 54,0.01)",
        borderColor: "rgba(37, 209, 54,1)",
        data: accounts_created[proxy_name]
    }
    data[:datasets] << {
        label: "#{proxy_name} Failed",
        backgroundColor: "rgba(216, 32, 32,0.01)",
        borderColor: "rgba(216, 32, 32,1)",
        data: accounts_not_created[proxy_name]
    }
  end


  data2 = {
      labels: [],
      datasets: [
      ]
  }
  i = 0
  accounts_created.each do |proxy_name, array|
    data2[:datasets] << {
        label: "#{proxy_name} Created",
        backgroundColor: @chartColors[@chartColors.keys[i % @chartColors.length]],
        borderWidth: 3,
        borderColor: "rgba(37, 209, 54, 1)",
        data: [ accounts_created[proxy_name].inject(0, :+) ]
    }
    data2[:datasets] << {
        label: "#{proxy_name} Failed",
        backgroundColor: @chartColors[@chartColors.keys[i % @chartColors.length]],
        borderWidth: 3,
        borderColor: "rgba(216, 32, 32, 1)",
        data: [ accounts_not_created[proxy_name].inject(0, :+) ]
    }
    i+=1
  end

  options = {}.merge(@chart_options)
  options = options.merge({ style: 'max-width:900px; min-height: 600px; max-height: 600px;', height: 600 })

  return ChartHelpers.chart('line', data, options) + ChartHelpers.chart('bar', data2, options)
end

module ChartHelpers
  CHART_TYPES = %w[ bar bubble doughnut horizontal_bar line pie polar_area radar scatter ]

  def self.chart(type, data, options)
    opts = options.dup

    @chart_id ||= -1
    element_id = opts.delete(:id)     || "chart-#{@chart_id += 1}"
    css_class  = opts.delete(:class)  || 'chart'
    css_style      = opts.delete(:style)  || 'max-height: 300px'
    height      = opts.delete(:height)  || 400
    width      = opts.delete(:width)  || 900

    canvas = content_tag :canvas, '', id: element_id, class: css_class, width: width, height: height, style:css_style

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
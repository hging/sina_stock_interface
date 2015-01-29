require "sina_stock_interface/version"
require "open-uri"
# 上证指数正则 /var hq_str_(\w*)="(\S*)";/
# a = open('http://hq.sinajs.cn/list=sh600005,sh600006').read.encode(Encoding.find("UTF-8"),Encoding.find("GBK"))
# a.scan(/var hq_str_(\w*)="(\S*)";/)
# a.scan(/var hq_str_(\w*)="(\S*)";/).collect{|x| x.join(",").split(",")}
=begin
数据结构(大盘指数)
[
  [
    "sz399001", #ID
    "深证成指", #指数名称
    "7775.371", #当前点数
    "-65.703", #当前价格
    "-0.84", #涨跌率
    "119551790", #成交量（手）
    "11073847" #成交额（万元）
  ], [
    "sh000001", 
    "上证指数", 
    "2204.472", 
    "-4.993", 
    "-0.23", 
    "1055135", 
    "9345129"
  ], [
    "sz399006", 
    "创业板指", 
    "1408.407", 
    "-12.133", 
    "-0.85", 
    "4865557", 
    "1007593"
  ]
]

数据结构(个股)
[
  [
    "sh600005", #股票ID
    "武钢股份", #股票名称
    "2.16", #今日开盘价
    "2.16", #昨日收盘价
    "2.15", #当前价格
    "2.17", #今日最高
    "2.14", #今日最低
    "2.15", #竞买价(买一)
    "2.16", #竞卖价(卖一)
    "10338739", #成交的股票数，由于股票交易以一百股为基本单位，所以在使用时，通常把该值除以一百； 
    "22275926", #成交金额，单位为“元”，为了一目了然，通常以“万元”为成交金额的单位，所以通常把该值除以一万；
    "146881", #买一申请股数
    "2.15", #买一报价
    "2010860", #买二股数
    "2.14", #买二报价
    "1351100", #买三股数
    "2.13", #买三报价
    "835500", #买四股数
    "2.12", #买四报价
    "424600", #买五股数
    "2.11", #买五报价
    "3307848", #卖一股数
    "2.16", #卖一报价
    "4852446", #卖二股数
    "2.17", #卖二报价
    "2077272", #卖三股数
    "2.18", #卖三报价
    "1218400", #卖四股数
    "2.19", #卖四报价
    "2194177", #卖五股数
    "2.20", #卖五报价
    "2014-08-28", #日期
    "13:34:55", #时间
    "00" #未知
    ], [
    "sh600006", 
    "东风汽车", 
    "4.31", 
    "4.40", 
    "4.39", 
    "4.55", 
    "4.21", 
    "4.39", 
    "4.40", 
    "40871061", 
    "178832662", 
    "177500", 
    "4.39", 
    "144600", 
    "4.38", 
    "251700", 
    "4.37", 
    "243600", 
    "4.36", 
    "342100", 
    "4.35", 
    "318350", 
    "4.40", 
    "27500", 
    "4.41", 
    "78900", 
    "4.42", 
    "151800", 
    "4.43", 
    "190400", 
    "4.44", 
    "2014-08-28", 
    "13:34:55", 
    "00"
  ]
]
数据结构(上交所股票信息):
[
  [
    "900956", 股票ID
    "东贝B股", 股票名称
    "dbBg" 名称拼音缩写
  ], [
    "900957", 
    "凌云B股", 
    "lyBg"
  ]
]
数据结构(搜索):
[
  [
    "300123",
    "11", 数据类型(11为股票,具体未知)
    "300123", 
    "sz300123", 股票ID
    "太阳鸟", 股票名称
    "tyn"
  ], [
    "000123", 
    "11", 
    "000123", 
    "sh000123", 
    "180动态", 
    "180dt"
  ], [
    "600123", 
    "11", 
    "600123", 
    "sh600123", 
    "兰花科创", 
    "lhkc"
  ]
]
=end

module SinaStockInterface
  class Data
    StockDataUrl = 'http://hq.sinajs.cn/list='
    def self.format_data(request)
      request.scan(/var hq_str_(\w*)="(.*)";/).collect{|x| x.join(",").split(",")}
    end
    def self.get_stock_data_by_id(stock_id)
      url = "#{StockDataUrl}#{stock_id}"
      respon =  RestClient.get(url)
      request = respon.force_encoding(respon.headers[:content_type].split('=').last).encode('UTF-8')
      # request = open(url).read.encode(Encoding.find("UTF-8"),Encoding.find("GBK"))
      format_data(request)
    end

    def self.get_stock_index_by_id(stock_index_id)
      url = "#{StockDataUrl}#{stock_index_id}"
      respon =  RestClient.get(url)
      request = respon.force_encoding(respon.headers[:content_type].split('=').last).encode('UTF-8')
      # request = open(url).read.encode(Encoding.find("UTF-8"),Encoding.find("GBK"))
      format_data(request)          
    end    
  end

  class Info
    SSEUrl = 'http://www.sse.com.cn/js/common/ssesuggestdata.js'
    SZSEUrl = 'http://www.szse.cn/szseWeb/FrontController.szse?ACTIONID=8&CATALOGID=1110&TABKEY=tab1&ENCODE=1'
    def self.get_sse_info
      format = /val:"(\w*)",val2:"(.*)",val3:"(\D*\w*)"}/
      request = open(SSEUrl).read.force_encoding('UTF-8')
      request.scan(format)
    end
    def self.get_szse_info
      format = /style='mso-number-\w*\D*(\w*)\D*center'.>(\D+)<\D*<td  class='cls-data-td'  align='left/
      request = open(SZSEUrl).read.force_encoding('UTF-8')
      request.scan(format)
    end
  end

  class Search
    def self.search(key)
      SearchUrl = 'http://suggest3.sinajs.cn/suggest/type=11,12,13,14,15&key='
      format = /"(\S*)"/
      url = URI.encode("#{SearchUrl}#{key}")
      respon =  RestClient.get(url)
      request = respon.force_encoding(respon.headers[:content_type].split('=').last).encode('UTF-8')
      # request = open(url).read.encode(Encoding.find("UTF-8"),Encoding.find("GBK"))
      request.scan(format)[0][0].split(';').collect{|a| a.split(',')}
    end
    def self.search_all(key)
      SearchUrl = 'http://suggest3.sinajs.cn/suggest/key='
      format = /"(\S*)"/
      url = URI.encode("#{SearchUrl}#{key}")
      respon =  RestClient.get(url)
      request = respon.force_encoding(respon.headers[:content_type].split('=').last).encode('UTF-8')
      # request = open(url).read.encode(Encoding.find("UTF-8"),Encoding.find("GBK"))
      request.scan(format)[0][0].split(';').collect{|a| a.split(',')}
    end
  end
end





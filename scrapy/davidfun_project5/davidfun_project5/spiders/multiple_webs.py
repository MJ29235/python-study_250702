import scrapy
# 2, items 잊지말고 클래스 찾아오기!
from davidfun_project5.items import DavidfunProject5Item


class MultipleWebsSpider(scrapy.Spider):
    name = "multiple_webs"
    allowed_domains = ["davelee-fun.github.io"]
    # start_urls = ["https://davelee-fun.github.io"]

    # 3, def start...
    def start_requests(self):
        urls =["https://davelee-fun.github.io"]
        urls.extend([f"https://davelee-fun.github.io/page{i}/"for i in range (2,7)])
        for url in urls :
            yield scrapy.Request(url, self.parse)


# 4, parse 함수사용서 titles 값 불러오기
    def parse(self, response):
        titles = response.css("h4.card-text::text").getall()
        for title in titles :
            item = DavidfunProject5Item()
            item["title"] = title 
            yield item

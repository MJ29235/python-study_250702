import scrapy
# davidfun_project2 내부에서 DavidfunProject2Item 이라는 클래스값을 찾아오기 (items에 저장했던!!)
from davidfun_project2.items import DavidfunProject2Item

class DavidfunSpider(scrapy.Spider):
    name = "davidfun"
    allowed_domains = ["davelee-fun.github.io"]
    start_urls = ["https://davelee-fun.github.io/"]

    def parse(self, response):
        #item에 DavidfunProject2Item(값)을 넣음
        item = DavidfunProject2Item()
        #title을 css로 값을 찾아오기
        item["title"] = response.css("h1.sitetitle::text").get()
        description = response.xpath("//p[@class='lead']/text()").get()
        #description을 xpath로 값 찾아오기, strip()은 앞뒤여백을 정리를 해주는 역할!
        item["description"] = description
            #if else문 한번써보기
        # if description:
        #     item["description"]= description.strip()
        # else :
        #     item["description"]= ""
        yield item

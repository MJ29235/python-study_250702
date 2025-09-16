import scrapy
# 1, items에 있는 클래스명 먼저 찾아오기
from davidfun_project3.items import DavidfunProject3Item

class CategorySpiderSpider(scrapy.Spider):
    name = "category_spider"
    allowed_domains = ["davelee-fun.github.io"]
    start_urls = ["https://davelee-fun.github.io"]

    def parse(self, response):
        # 2, 크롤링 할 값 넣기, getall
        categories = response.css("a.text-dark::text").getall()
        # 3, 리스트로 들어오기 때문에 반복문!
        for category in categories :

            item = DavidfunProject3Item()
            # 4, items에 카테고리라는 요소가 있는지확인, 붙여넣기
            item["category"] = category
            # 5, yield
            yield item

# pipeline 으로 가서 중복방지 설정! 
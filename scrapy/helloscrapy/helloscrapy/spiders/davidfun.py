import scrapy


class DavidfunSpider(scrapy.Spider):
    name = "davidfun"
    allowed_domains = ["davelee-fun.github.io"]
    start_urls = ["https://davelee-fun.github.io/"]

    def parse(self, response):
        #이 밑의 영역을 Field라고 부름
        
        #css selector 방식
        title = response.css("h1.sitetitle::text").get()
        #xpath 방식 (=파이썬)
        description = response.xpath("//p[@class='lead']/text()").get()
        #pass는실질적으로 쓰지않고, 실행한다는 뜻의 yield
        #크롤링에 성공한 데이터를 딕셔너리의 형태로 저장하겠다!
        yield{
            "title": title,
            "description": description.strip()
        }

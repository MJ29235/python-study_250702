import scrapy
from davidfun_project4.items import DavidfunProject4Item


class MultipleWebsSpider(scrapy.Spider):
    name = "multiple_webs"
    allowed_domains = ["davelee-fun.github.io"]
    start_urls = ["https://davelee-fun.github.io"]
    # 1, start_urls 굳이 필요없음!
    # 2, def star... -> 내장되어있는 함수! Framework! 문법쓰고싶으면 써라
    def start_requests(self):
        # 3, url 넣기
        urls = ["https://davelee-fun.github.io"]
        # 4, list comprehension -> 리스트 반복순회를 통해 값을 하나씩 넣겠다!
        urls.extend([f"https://davelee-fun.github.io/page{i}/" for i in range(2,7)]) # 5, urls 확장시킬것, ([이터러블한 객체])
        # 6, i값을 찾아와서 하나씩 증가시키겠다
        # 7, url 값이 이제 채워질 것. urls = 리스트
        for url in urls: 
            # 8, url 에서 찾아온 값을 스스로 파싱해라
            yield scrapy.Request(url, self.parse)
            # 10, yield 때문에 def를 연속적으로 쓸 수 있음! 이터러블하지 못한 객체를 이터러블하게 만들어주는 get,set : 반복순회 속성을 가짐. 이와 같이 나온 것이 yield : 약속되어진 어떤 단계를 명령하지않아도 해라! <-> return 은 끝났으면 값을 반환하고 끝내 

    def parse(self, response): # 9, 파싱되어진 결과값에서 가공을해라.
        # 10, titles 는 리스트의 형식 getall때문에
        titles = response.css("h4.card-text::text").getall()
        
        for title in titles:
            item = DavidfunProject4Item()
            item["title"] = title
            # 11, 반복문이기 때문에 yield가 쓰이는 것!
            yield item # 12, yield는 이미 값을 DavidfunProject4Item로 보내주기로 약속

        # 13, 결과 도출 (터미널 :scrapy crawl multiple_webs -o multiple_webs_item.json)
# 14, pipeline으로 개행 없애기! -> project5
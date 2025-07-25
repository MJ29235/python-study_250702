# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
# 7, DropItem 설치!
from scrapy.exceptions import DropItem

# 6, pipeline에 카테고리 깨끗하게 청소해주는 만들기!
class CleanCategoryPipeline:
    def process_item(self, item, spider):
        item["category"] = item["category"].strip()
        return item
# 8, pipeline 중복되는 값 없애는것 만들기! set -> 노션 설명
class SetPipeline:
    # 9, 기존에 정의되어있는 자기 자신(self)의 값을 가져오고 싶음!->__init__ (생성자함수)
    def __init__(self):
        # 10, 카테고리가 들어와져서 봤다!(라는 의미로 seen이라고 칭함) self에서 중복된 값을 받지 않지위해 set!
        self.categories_seen =set() 

    def process_item(self, item, spider):
        # 11, 카테고리라고 불리는 것에 동일한 것이 있다면 삭제하려고 하는 값을 보여줘!
        if item["category"] in self.categories_seen :
            # 12, 어떠한 값이 중복되어졌는지 출력(%s)하고 삭제(DropItem)하겠다
            raise DropItem("Duplicate item found : %s " % item)
        # 13, 없다면 카테고리에 값을 추가해줘! 
        else :
            self.categories_seen.add(item["category"])
            return item
# 14, "관련 상품 추천"이라는 문자를 찾으면 삭제하고 빈 문자열로 출력
class RemovePhrasePipeline :
    def process_item(self, item, spider):
        item["category"] = item["category"].replace(" 관련 상품 추천","")
        return item
    
# 15, settings로 이동!
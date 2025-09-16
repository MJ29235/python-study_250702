# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter

# 5, 제목을 바꾸고 상품명 없앰. 빈공백 없애기
class CleanTitlePipeline:
    def process_item(self, item, spider):
        item["title"] = item["title"].replace("상품명: ","")
        item["title"] = item["title"].strip()
        return item

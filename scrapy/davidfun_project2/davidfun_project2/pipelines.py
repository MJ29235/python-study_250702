# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
from scrapy.exceptions import DropItem #dropdown 신경쓰지마라


class DavidfunProject2Pipeline:
    #원래 있던 구문들은 함부러 삭제하면 안됨!
    def process_item(self, item, spider):
        #함수의 기능을 부여하기!
        if item["description"]:
            item["description"]= item["description"].strip()
            #davidfun이 크롤링해온 description에 strip을 넣어라!
            return item
        else:
            raise DropItem("Missing description in %s" % item)
        #%s -> 형식지정자, 여기서s는 문자열! items 안에 디스크립션이 있다면 davidfun이 찾아온 값을 앞뒤 여백을 없애고 description에 넣어라!
        #dropItem은  string 값을 못찾아오면, 잃어버린 디스크립션은 소멸시키겠다. (저장할 공간이 없기 떄문에!)
        

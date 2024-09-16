# Customerデータの作成
customers = [
  { name: "Yamada Taro", email: "yamada.taro@gmail.com", password: "111111" },
  { name: "Sato Mamoru", email: "sato.mamoru@gmail.com", password: "111111" },
  { name: "Tanaka Saki", email: "tanaka.saki@gmail.com", password: "111111" },
  { name: "Hoshino Yui", email: "hoshino.yui@gmail.com", password: "111111" },
  { name: "Saito Kazuma", email: "saito.kazuma@gmail.com", password: "111111" }
]

customers.each do |customer_data|
  customer = Customer.new(customer_data)
  unless customer.save
    puts "Failed to create customer: #{customer.email}"
    puts customer.errors.full_messages
  end
end

# admin パスワード
# db/seeds.rb

admin = Admin.find_or_initialize_by(email: "admin@gmail.com")
admin.password = "1234qwer"

if admin.save
  puts "Admin created or updated successfully: #{admin.email}"
else
  puts "Failed to create or update admin:"
  puts admin.errors.full_messages
end

#商品
product1 = Product.new(
  name: "canned cat food1",
  description: "商品紹介：\nお魚の端材や血合いを原料としており、人間も食べられるヒューマングレードのキャットフードです。猫ちゃんの健康を第一に考え、塩分は丁寧に取り除きました。本商品は加熱することなく冷凍保存しております。\n\n原材料名：\n45g x 2\n\nブリ、しいら、まだい、めじな、かつお、スマガツオ\n\n内容量：\n45g x 2\n\n保存方法：\n常温で保存してください。",
  price: 4200,
  stock: 30
)
product1.image.attach(io: File.open(Rails.root.join('app/assets/images/food1.jpg')), filename: 'food1.jpg')
# タグを追加
product1.tag_list.add("カツオ", "グルテンフリー")

# 保存とエラーチェック
unless product1.save
    puts product1.errors.full_messages
  end

product2 = Product.new(
  name: "canned cat food2",
  description: "商品紹介：\nお魚の端材や血合いを原料としており、人間も食べられるヒューマングレードのキャットフードです。猫ちゃんの健康を第一に考え、塩分は丁寧に取り除きました。本商品は加熱することなく冷凍保存しております。\n\n原材料名：\n45g x 2\n\nブリ、しいら、まだい、めじな、かつお、スマガツオ\n\n内容量：\n45g x 2\n\n保存方法：\n常温で保存してください。",
  price: 24800, 
  stock: 21
)
product2.image.attach(io: File.open(Rails.root.join('app/assets/images/food2.jpg')), filename: 'food2.jpg')
# タグを追加
product2.tag_list.add("サバ", "グルテンフリー")

# 保存とエラーチェック
unless product2.save
    puts product2.errors.full_messages
  end

product3 = Product.new(
  name: "canned cat food3",
  description: "商品紹介：<br>お魚の端材や血合いを原料としており、人間も食べられるヒューマングレードのキャットフードです。猫ちゃんの健康を第一に考え、塩分は丁寧に取り除きました。本商品は加熱することなく冷凍保存しております。<br><br>原材料名：<br>45g x 2<br><br>ブリ、しいら、まだい、めじな、かつお、スマガツオ<br><br>内容量：<br>45g x 2<br><br>保存方法：<br>常温で保存してください。",
  price: 5780, 
  stock: 10
)
product3.image.attach(io: File.open(Rails.root.join('app/assets/images/food3.jpg')), filename: 'food3.jpg')
# タグを追加
product3.tag_list.add("サーモン", "グルテンフリー")
# 保存とエラーチェック
unless product3.save
    puts product3.errors.full_messages
  end

product4 = Product.new(
  name: "canned cat food4",
  description: "商品紹介：<br>お魚の端材や血合いを原料としており、人間も食べられるヒューマングレードのキャットフードです。猫ちゃんの健康を第一に考え、塩分は丁寧に取り除きました。本商品は加熱することなく冷凍保存しております。<br><br>原材料名：<br>45g x 2<br><br>ブリ、しいら、まだい、めじな、かつお、スマガツオ<br><br>内容量：<br>45g x 2<br><br>保存方法：<br>常温で保存してください。",
  price: 3900, 
  stock: 12
)
product4.image.attach(io: File.open(Rails.root.join('app/assets/images/food4.jpg')), filename: 'food4.jpg')
# タグを追加
product4.tag_list.add("サーモン", "グルテンフリー")
# 保存とエラーチェック
unless product4.save
    puts product4.errors.full_messages
  end

product5 = Product.new(
  name: "canned cat food5",
  description: "商品紹介：<br>お魚の端材や血合いを原料としており、人間も食べられるヒューマングレードのキャットフードです。猫ちゃんの健康を第一に考え、塩分は丁寧に取り除きました。本商品は加熱することなく冷凍保存しております。<br><br>原材料名：<br>45g x 2<br><br>ブリ、しいら、まだい、めじな、かつお、スマガツオ<br><br>内容量：<br>45g x 2<br><br>保存方法：<br>常温で保存してください。",
  price: 8900, 
  stock: 8
)
product5.image.attach(io: File.open(Rails.root.join('app/assets/images/food5.jpg')), filename: 'food5.jpg')
# タグを追加
product5.tag_list.add("カツオ", "添加物未使用")
# 保存とエラーチェック
unless product5.save
    puts product5.errors.full_messages
  end

product6 = Product.new(
  name: "canned cat food6",
  description: "商品紹介：<br>お魚の端材や血合いを原料としており、人間も食べられるヒューマングレードのキャットフードです。猫ちゃんの健康を第一に考え、塩分は丁寧に取り除きました。本商品は加熱することなく冷凍保存しております。<br><br>原材料名：<br>45g x 2<br><br>ブリ、しいら、まだい、めじな、かつお、スマガツオ<br><br>内容量：<br>45g x 2<br><br>保存方法：<br>常温で保存してください。",
  price: 3200, 
  stock: 30
)
product6.image.attach(io: File.open(Rails.root.join('app/assets/images/food6.jpg')), filename: 'food6.jpg')
# タグを追加
product6.tag_list.add("固形", "グルテンフリー")
# 保存とエラーチェックQ
unless product6.save
    puts product6.errors.full_messages
  end

product7 = Product.new(
  name: "canned cat food7",
  description: "商品紹介：<br>お魚の端材や血合いを原料としており、人間も食べられるヒューマングレードのキャットフードです。猫ちゃんの健康を第一に考え、塩分は丁寧に取り除きました。本商品は加熱することなく冷凍保存しております。<br><br>原材料名：<br>45g x 2<br><br>ブリ、しいら、まだい、めじな、かつお、スマガツオ<br><br>内容量：<br>45g x 2<br><br>保存方法：<br>常温で保存してください。",
  price: 3200, 
  stock: 30
)
product7.image.attach(io: File.open(Rails.root.join('app/assets/images/food7.jpg')), filename: 'food7.jpg')
# タグを追加
product7.tag_list.add("サーモン", "無添加")
# 保存とエラーチェック
unless product7.save
    puts product7.errors.full_messages
  end

product8 = Product.new(
  name: "kibble1",
  description: "商品紹介：<br>お魚の端材や血合いを原料としており、人間も食べられるヒューマングレードのキャットフードです。猫ちゃんの健康を第一に考え、塩分は丁寧に取り除きました。本商品は加熱することなく冷凍保存しております。<br><br>原材料名：<br>45g x 2<br><br>ブリ、しいら、まだい、めじな、かつお、スマガツオ<br><br>内容量：<br>45g x 2<br><br>保存方法：<br>常温で保存してください。",
  price: 3200, 
  stock: 30
)

product8.image.attach(io: File.open(Rails.root.join('app/assets/images/kibble1.jpg')), filename: 'kibble1.jpg')
# タグを追加
product8.tag_list.add("無添加", "子猫")
# 保存とエラーチェック
unless product8.save
    puts product8.errors.full_messages
  end

product9 = Product.new(
  name: "kibble2",
  description: "商品紹介：<br>お魚の端材や血合いを原料としており、人間も食べられるヒューマングレードのキャットフードです。猫ちゃんの健康を第一に考え、塩分は丁寧に取り除きました。本商品は加熱することなく冷凍保存しております。<br><br>原材料名：<br>45g x 2<br><br>ブリ、しいら、まだい、めじな、かつお、スマガツオ<br><br>内容量：<br>45g x 2<br><br>保存方法：<br>常温で保存してください。",
  price: 3200, 
  stock: 30
)
product9.image.attach(io: File.open(Rails.root.join('app/assets/images/kibble2.jpg')), filename: 'kibble2.jpg')
# タグを追加
product9.tag_list.add("固形", "グルテンフリー","無添加")
# 保存とエラーチェック
unless product9.save
    puts product9.errors.full_messages
  end

product10 = Product.new(
  name: " kibble3",
  description: "商品紹介：<br>お魚の端材や血合いを原料としており、人間も食べられるヒューマングレードのキャットフードです。猫ちゃんの健康を第一に考え、塩分は丁寧に取り除きました。本商品は加熱することなく冷凍保存しております。<br><br>原材料名：<br>45g x 2<br><br>ブリ、しいら、まだい、めじな、かつお、スマガツオ<br><br>内容量：<br>45g x 2<br><br>保存方法：<br>常温で保存してください。",
  price: 3200, 
  stock: 30
)
product10.image.attach(io: File.open(Rails.root.join('app/assets/images/kibble3.jpg')), filename: 'kibble3.jpg')
# タグを追加
product10.tag_list.add("固形","無添加")
# 保存とエラーチェック
unless product10.save
    puts product10.errors.full_messages
  end
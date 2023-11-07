-- 86. a.Bu ülkeler hangileri..? 
select distinct country as "İhracat yapılan ülke sayısı" from customers
 
-- 87. En Pahalı 5 ürün
select unit_price from products p
order by unit_price desc limit 5
-- 88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
select o.customer_id, SUM(od.quantity) from orders o
inner join order_details od on od.order_id = o.order_id
where o.customer_id = 'ALFKI'
group by o.customer_id
-- 89. Ürünlerimin toplam maliyeti
select sum(p.unit_price * p.units_in_stock) from products p


-- 90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
SELECT SUM(od.unit_price * od.quantity) AS total_revenue, o.order_date
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
group by o.order_date;
-- 91. Ortalama Ürün Fiyatım
select avg(unit_price)from products

-- 92. En Pahalı Ürünün Adı
select product_name from products 
where unit_price = (select max(unit_price) from products)
-- 93. En az kazandıran sipariş
SELECT (od.unit_price * od.quantity) AS revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
group by revenue
order by revenue limit 1;
-- 94. Müşterilerimin içinde en uzun isimli müşter

select contact_name from customers
where length(contact_name) = (select max(length(contact_name)) from customers);

-- 95. Çalışanlarımın Ad, Soyad ve Yaşları
select first_name, last_name, (date_part('year', current_date) - date_part('year', birth_date)) Age 
from employees;

-- 96. Hangi üründen toplam kaç adet alınmış..?
select p.product_name, od.quantity from products p
inner join order_details od on od.product_id = p.product_id
group by p.product_name, od.quantity 

-- 97. Hangi siparişte toplam ne kadar kazanmışım..?

SELECT o.order_id, SUM(od.unit_price * od.quantity) AS total_revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
group by o.order_id;

-- 98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select c.category_name, count(p.units_in_stock) from categories c
inner join products p on p.category_id = c.category_id
group by c.category_name

-- 99. 1000 Adetten fazla satılan ürünler?
select product_id  , sum(quantity) from order_details
group by product_id
having sum(quantity) > 1000
-- 100. Hangi Müşterilerim hiç sipariş vermemiş..?
select c.customer_id, c.contact_name, o.customer_id from customers c
left join orders o on o.customer_id = c.customer_id
where o.customer_id is null
-- 101. Hangi tedarikçi hangi ürünü sağlıyor ?
select s.contact_name, p.product_name from suppliers s
inner join products p on p.supplier_id = s.supplier_id
group by s.contact_name, p.product_name

-- 102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
select o.order_id, s.company_name, o.order_date from shippers s
inner join orders o on o.ship_via = s.shipper_id
group by o.order_id, s.company_name, o.order_date

-- 103. Hangi siparişi hangi müşteri verir..?
select o.order_id, c.contact_name from customers c
inner join orders o on o.customer_id = c.customer_id
group by  o.order_id, c.contact_name

-- 104. Hangi çalışan, toplam kaç sipariş almış..?
select e.employee_id, count(o.*) from orders o
inner join employees e on e.employee_id = o.employee_id
group by e.employee_id

-- 105. En fazla siparişi kim almış..?
select c.contact_name, max(od.quantity) from customers c
inner join orders o on o.customer_id = c.customer_id
inner join order_details od on od.order_id = o.order_id
group by c.contact_name
order by  max(od.quantity) desc limit 1

-- 106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
select o.order_id, e.first_name || ' ' || e.last_name as "Worker", c.contact_name from orders o
inner join customers c on o.customer_id = c.customer_id
inner join employees e on e.employee_id = o.employee_id
group by o.order_id, e.first_name, e.last_name, c.contact_name

-- 107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
select p.product_name, c.category_name, s.contact_name as "suppliers" from products p 
inner join categories c on c.category_id = p.category_id
inner join suppliers s on s.supplier_id = p.supplier_id
group by p.product_name, c.category_name, s.contact_name 

-- 108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
select o.order_id, c.contact_name, e.employee_id, o.order_date, k.company_name, p.product_name, od.quantity, p.unit_price, m.category_name, s.supplier_id from orders o
inner join employees e on e.employee_id = o.employee_id
inner join customers c on o.customer_id = c.customer_id
inner join order_details od on o.order_id = od.order_id
inner join products p on p.product_id = od.product_id
inner join suppliers s on s.supplier_id = p.supplier_id
inner join categories m on m.category_id = p.category_id
inner join shippers k on k.shipper_id = o.ship_via
group by o.order_id, c.contact_name, e.employee_id, o.order_date, k.company_name, p.product_name, od.quantity, p.unit_price, m.category_name, s.supplier_id

-- 109. Altında ürün bulunmayan kategoriler
select * from categories where  not EXISTs ( select category_id from products )
	
-- 110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
select contact_name, contact_title from customers
where contact_title Like '%Manager%'

-- 111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
select *from customers
where customer_id Like 'FR___'
-- 112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
select *from customers
where phone like '(171)%'
-- 113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.
select * from products
where quantity_per_unit like '%boxes%'

-- 114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
select contact_name, phone, contact_title, country from customers
where contact_title Like '%Manager%' and country in ('France' , 'Germany')

-- 115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
select unit_price from products
order by unit_price desc limit 10

-- 116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
select contact_name, country, city from customers
order by  country, city desc
-- 117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
select first_name, last_name, (date_part('year', current_date) - date_part('year', birth_date)) Age 
from employees;

-- 118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
select * from orders
where (order_date + 35) < shipped_date

-- 119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
select category_name from categories where category_id = (select category_id from products  order by unit_price desc limit 1)

-- 120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
select product_name from products where category_id in (select category_id from categories where category_name like '%on%')
										   
-- 121. Konbu adlı üründen kaç adet satılmıştır.
select quantity from order_details where product_id in (select product_id from products where product_name = 'Konbu')

-- 122. Japonyadan kaç farklı ürün tedarik edilmektedir.
select product_name from products where supplier_id in (select supplier_id from suppliers where country = 'Japan')

-- 123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
select max(freight), min(freight), avg(freight) from orders where date_part('year', order_date) = 1997

-- 124. Faks numarası olan tüm müşterileri listeleyiniz.
select * from customers 
where fax is not null
-- 125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
select * from orders where order_date between '1996-07-16' and '1996-07-30'

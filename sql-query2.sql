-- 26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select p.product_id, p.product_name, a.company_name, a.phone from products p
inner join suppliers a on a.supplier_id = p.supplier_id
where p.units_in_stock = 0
group by p.product_id, p.product_name, a.company_name, a.phone

-- 27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select m.order_date, m.ship_address, k.first_name, k.last_name from employees k
inner join orders m on m.employee_id= k.employee_id
where date_part('year', m.order_date) = 1998 and date_part('month', m.order_date) = 3;

-- 28. 1997 yılı şubat ayında kaç siparişim var?
select m.order_date, a.quantity from orders m 
inner join order_details a on a.order_id = m.order_id
where date_part('year', m.order_date) = 1997 and date_part('month', m.order_date) = 2;

-- 29. London şehrinden 1998 yılında kaç siparişim var?
select m.order_date, a.quantity from orders m 
inner join order_details a on a.order_id = m.order_id
where m.ship_city = 'London' and date_part('year', m.order_date) = 1998

-- 30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select contact_name, phone from customers c
inner join orders m on m.customer_id = c.customer_id
where date_part('year', m.order_date) = 1997
group by contact_name, phone

-- 31. Taşıma ücreti 40 üzeri olan siparişlerim
select* from orders
where freight > 40

-- 32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select m.ship_city, c.contact_name from orders m
inner join customers c on c.customer_id = m.customer_id
where freight > 40
group by m.ship_city, c.contact_name

-- 33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
select m.order_date, m.ship_city, k.first_name || ' ' || k.last_name as "ad soyad" from orders m
inner join employees k on k.employee_id = m.employee_id
where date_part('year', m.order_date) = 1997

-- 34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select m.order_date, c.contact_name, regexp_replace(c.phone, '[^0-9]','', 'g') from orders m
inner join customers c on c.customer_id = m.customer_id
where date_part('year', m.order_date) = 1997
group by m.order_date, c.contact_name, c.phone

-- 35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select m.order_date, m.ship_city, k.first_name, k.last_name from orders m
inner join customers c on c.customer_id = m.customer_id
inner join employees k on k.employee_id = m.employee_id
group by m.order_date, m.ship_city, k.first_name, k.last_name

-- 36. Geciken siparişlerim?
select* from orders
where ( shipped_date > required_date ) 

-- 37. Geciken siparişlerimin tarihi, müşterisinin adı
select m.order_date, c.contact_name from orders m
inner join customers c on c.customer_id = m.customer_id
where ( shipped_date > required_date ) 

-- 38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select c.category_name, a.quantity from products p
inner join order_details a on a.product_id = p.product_id
inner join categories c on c.category_id = p.category_id
where a.order_id =10248
group by c.category_name, a.quantity

-- 39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name, s.contact_name from products p
inner join order_details a on a.product_id = p.product_id
inner join suppliers s on s.supplier_id = p.supplier_id
where a.order_id =10248
group by p.product_name, s.contact_name

-- 40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name, a.quantity from order_details a
inner join products p on a.product_id = p.product_id
inner join orders m on m.order_id = a.order_id
where m.employee_id =3 and date_part('year', m.order_date) = 1997

-- 41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select k.employee_id , k.first_name, k.last_name, MAX(a.quantity) as max_quantity from employees k
inner join orders m on m.employee_id = k.employee_id
inner join order_details a on m.order_id = a.order_id
where date_part('year', m.order_date) = 1997
group by k.employee_id , k.first_name, k.last_name
order by max_quantity DESC Limit 1;

-- 42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select k.employee_id , k.first_name, k.last_name, sum(a.quantity) from employees k
inner join orders m on m.employee_id = k.employee_id
inner join order_details a on m.order_id = a.order_id
where date_part('year', m.order_date) = 1997
group by k.employee_id , k.first_name, k.last_name
order by sum(a.quantity) DESC Limit 1;

-- 43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir
select p.product_name, p.unit_price, c.category_name, Max(p.unit_price) from products p
inner join categories c on c.category_id = p.category_id
group by p.product_name, p.unit_price, c.category_name
order by Max(p.unit_price) DESC Limit 1;

-- 44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select  k.first_name, k.last_name, m.order_date, m.order_id from employees k
inner join orders m on m.employee_id = k.employee_id
inner join order_details a on m.order_id = a.order_id
group by   k.first_name, k.last_name, m.order_date, m.order_id
order by m.order_date DESC 

-- 45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select avg(p.unit_price), a.order_id from products p
inner join order_details a on p.product_id = a.product_id
group by a.order_id
order by avg(p.unit_price) desc limit 5;

-- 46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name, c.category_name, sum(a.quantity) from products p
inner join order_details a on p.product_id = a.product_id
inner join categories c on c.category_id = p.category_id
inner join orders m on m.order_id = a.order_id
where date_part('month', m.order_date) = 1
group by p.product_name, c.category_name
order by sum(a.quantity) DESC;

-- 47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select  avg(a.quantity)  from order_details 
select a.quantity, a.order_id from order_details
where a.quantity > (select  avg(a.quantity)  from order_details );

-- 48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select c.category_name, t.contact_name from products p
inner join suppliers t on t.supplier_id = p.supplier_id
inner join categories c on c.category_id = p.category_id
group by c.category_name, t.contact_name

-- 49. Kaç ülkeden müşterim var
select  country from customers
group by country

-- 50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select sum(p.unit_price) from products p
inner join order_details od on od.product_id = p.product_id
inner join orders o on o.order_id = od.order_id
where employee_id = 3 and date_part('month', o.order_date)=1 and o.order_date <= current_date

-- 51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select c.category_name, a.quantity from products p
inner join order_details a on a.product_id = p.product_id
inner join categories c on c.category_id = p.category_id
where a.order_id =10248
group by c.category_name, a.quantity

-- 52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name, s.contact_name from products p
inner join order_details a on a.product_id = p.product_id
inner join suppliers s on s.supplier_id = p.supplier_id
where a.order_id =10248

-- 53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name, a.quantity from order_details a
inner join products p on a.product_id = p.product_id
inner join orders m on m.order_id = a.order_id
where m.employee_id =3 and date_part('year', m.order_date) = 1997

-- 54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select k.employee_id , k.first_name, k.last_name, MAX(a.quantity) as max_quantity from employees k
inner join orders m on m.employee_id = k.employee_id
inner join order_details a on m.order_id = a.order_id
where date_part('year', m.order_date) = 1997
group by k.employee_id , k.first_name, k.last_name
order by max_quantity DESC Limit 1;

-- 55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select k.employee_id , k.first_name, k.last_name, sum(a.quantity) from employees k
inner join orders m on m.employee_id = k.employee_id
inner join order_details a on m.order_id = a.order_id
where date_part('year', m.order_date) = 1997
group by k.employee_id , k.first_name, k.last_name
order by sum(a.quantity) DESC Limit 1;

-- 56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name, Max(p.unit_price) from products p
inner join categories c on c.category_id = p.category_id
group by p.product_name, p.unit_price, c.category_name
order by Max(p.unit_price) DESC Limit 1;

-- 57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select  k.first_name, k.last_name, m.order_date, m.order_id from employees k
inner join orders m on m.employee_id = k.employee_id
inner join order_details a on m.order_id = a.order_id
group by   k.first_name, k.last_name, m.order_date, m.order_id
order by m.order_date DESC 

-- 58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select avg(p.unit_price), a.order_id from products p
inner join order_details a on p.product_id = a.product_id
group by a.order_id
order by avg(p.unit_price) desc limit 5;

-- 59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select avg(p.unit_price), a.order_id from products p
inner join order_details a on p.product_id = a.product_id
group by a.order_id
order by avg(p.unit_price) desc limit 5;

-- 60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select  avg(a.quantity)  from order_details 
select a.quantity, a.order_id from order_details
where a.quantity > (select  avg(a.quantity)  from order_details );

-- 61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select c.category_name, t.contact_name from products p
inner join suppliers t on t.supplier_id = p.supplier_id
inner join categories c on c.category_id = p.category_id
group by c.category_name, t.contact_name

-- 62. Kaç ülkeden müşterim var
select  country from customers
group by country

-- 63. Hangi ülkeden kaç müşterimiz var
select country, count(*)as "müşteri sayısı" from customers
group by country

-- 64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select sum(p.unit_price) from products p
inner join order_details od on od.product_id = p.product_id
inner join orders o on o.order_id = od.order_id
where employee_id = 3 and date_part('month', o.order_date)=1 and o.order_date <= current_date

-- 65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select sum(p.unit_price * a.quantity) as toplam_ciro from products p
inner join order_details a on a.product_id = p.product_id
inner join orders m on m.order_id = a.order_id
where p.product_id = 10 and m.order_date <= current_date- interval '3 month'

-- 66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select e.first_name, e.last_name, sum(od.quantity) from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id = o.order_id
group by e.first_name, e.last_name;

-- 67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select * from customers
Where customer_id not in (select distinct customer_id from orders);

-- 68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name, contact_name, address, city, country from customers
where country = 'Brazil';


-- 69. Brezilya’da olmayan müşteriler
select * from customers
where country <> 'Brazil';

-- 70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select * from customers
where country IN ('Spain','France','Germany');

-- 71. Faks numarasını bilmediğim müşteriler
select * from customers
where fax is null

-- 72. Londra’da ya da Paris’de bulunan müşterilerim
select * from customers
where city IN ('London','Paris')

-- 73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select * from customers
where city = 'México D.F.' And contact_title = 'Owner';

-- 74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name, unit_price from products
where product_name LIKE 'C%';

-- 75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name, last_name,birth_date from employees
where first_name LIKE 'A%';

-- 76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select * from customers
where company_name LIKE '%Restaurant%'

-- 77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name, unit_price from products
where unit_price Between '50' and '100';

-- 78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
select order_id, order_date from orders
where order_date Between '1996-07-01' AND '1996-12-31';

-- 79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select * from customers
where country IN ('Spain','France','Germany');

-- 80. Faks numarasını bilmediğim müşteriler
select * from customers
where fax is null

-- 81. Müşterilerimi ülkeye göre sıralıyorum:
select * from customers
order by country asc

-- 82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price from products
order by unit_price DESC

-- 83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price, units_in_stock from products
order by unit_price DESC, units_in_stock asc

-- 84. 1 Numaralı kategoride kaç ürün vardır..?
select count(*) from products
where category_id=1

-- 85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct country) as "İhracat yapılan ülke sayısı" from customers


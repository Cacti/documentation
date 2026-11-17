# Cacti kurulum ve işletim kılavuzu

Bu belge, yeni kurulumlar için eski Türkçe katkının yerini alan yeni bir
kılavuzdur. Henüz yayımlanmamış Cacti 1.3 `develop` dalını anlatır. Cacti 1.2
kullanıyorsanız [1.2.x el kitabını][stable] izleyin. Türkçe başlangıç bölümü
yeniden yazılmıştır; eksiksiz ek bölüm güncel İngilizce bölümleri içerir.
Bu belge, el kitabının tamamının Türkçe çevirisi değildir.

## Sürüm ve platform seçimi

Önce [gereksinimleri][requirements] denetleyin. Güvenlik güncellemeleri alan
bir işletim sistemi ve seçilen Cacti dalına uygun PHP, veritabanı ve RRDtool
kullanın. Komut satırı PHP'si ile web sunucusunun kullandığı PHP farklı
ayar dosyaları yükleyebilir; ikisini de kurucuda doğrulayın.

Linux için [Ubuntu/Debian][debian] veya [Enterprise Linux][linux] kurulumunu
izleyin. Apache ve nginx yapılandırmalarını birbirinin yerine kullanmayın.
FreeBSD paketleri için [genel kurulumdaki][install] PHP çeşidi ve dizin
bilgilerini okuyun. Bir Cacti 1.2 paketi, geliştirme sürümüne eşdeğer değildir.

## Kuruluma hazırlık

Mevcut bir sistemi değiştirmeden önce veritabanını, yapılandırmayı ve RRD
verilerini yedekleyin. Yedeğin geri yüklenebildiğini sınayın. Seçtiğiniz
platform kılavuzuna göre PHP, veritabanı, RRDtool ve Net-SNMP kurun.
Kaynak koddan kurulumda, dağıtım sahibi olarak kilitlenmiş bağımlılıkları
kurun:

```sh
composer install --no-dev
composer check-platform-reqs --no-dev
php --ini
php -m
```

Platform denetimi başarısız olursa devam etmeyin. `cacti.sql` dosyasını
yalnızca
yeni bir veritabanına aktarın; mevcut veritabanının üzerine aktarmayın.
Mevcut kurulum için Cacti'nin yükseltme işlemini kullanın. Parolaları komut
satırında, ekran görüntülerinde veya destek iletilerinde paylaşmayın.

## Web erişimi ve veri toplama

Gerçek veritabanı bağlantı bilgilerini `include/config.php` içinde tanımlayın.
Bu dosyayı ve uygulama kodunu web sunucusunun değiştirmesine izin vermeyin.
Veri toplama hesabına yalnızca gerekli çalışma dizinlerinde yazma izni verin.
Web sunucusu ve poller için ayrı, yetkileri sınırlı hesaplar kullanın.

Kurulum sırasında web erişimini sınırlayın ve HTTPS yapılandırın. Web kurucunun
PHP, dizin, saat dilimi ve veritabanı denetimlerini tamamlayın. İlk oturumda
başlangıç parolasını değiştirin. PHP ve `poller.php` için mutlak yolları
kullanan
tek bir zamanlama oluşturun. Aynı anda ikinci poller çalıştırmayın.
[Spine][spine] isteğe bağlıdır ve Cacti sürümüyle uyumlu olmalıdır.

## İlk cihaz ve grafikler

**Console > Devices** bölümünde uygun şablonla cihaz ekleyin. SNMP sürümünü ve
kimlik bilgilerini cihazın ayarlarıyla eşleştirin. Cihazın SNMP erişimini
collector adresiyle sınırlayın. Grafik oluşturun ve bir ağaca ekleyin.
Sonuçları değerlendirmeden önce birkaç veri toplama aralığı bekleyin.
[İlk grafik adımlarını][graphs] izleyin.

![Geçmiş örnek veriler içeren grafik](../../images/graphs-edit.png)

Görüntü eski bir arayüzü ve geçmiş örnek ölçümleri gösterir.

## Sorun giderme ve yükseltme

Önce servisleri, sistem saatini, CLI ve web PHP ayarlarını, çalıştırılabilir
dosya yollarını ve hesap izinlerini denetleyin. Cacti günlüğüne bakın ve tek
bir veri kaynağı için [hata ayıklama araçlarını][debug] kullanın. Ayrıntılı
loglamayı yalnızca gerekli cihazlarda geçici olarak açın. Boş bir grafik
nedeniyle RRD dosyalarını silmeyin veya veritabanını yeniden oluşturmayın.

Yükseltmeden önce sürüm notlarını ve [yükseltme kılavuzunu][upgrade] okuyun.
Veritabanı, RRD verisi, yapılandırma, eklentiler ve zamanlamaları yedekleyin.
Önce deneme ortamında doğrulayın. Veritabanı yükseltmesini bir kez çalıştırın.
Kurulumu kullanıcılara açmadan önce [güvenlik adımlarını][hardening] uygulayın.

[stable]: https://github.com/Cacti/documentation/blob/1.2.x/README.md
[requirements]: ../../Requirements.md
[install]: ../../General-Installing-Instructions.md
[linux]: ../../Install-Under-Enterprise-Linux-LAMP.md
[debian]: ../../Installing-Under-Ubuntu-Debian.md
[spine]: ../../Spine.md
[graphs]: ../../How-to-Graph-Your-Network.md
[debug]: ../../Data-Debug.md
[upgrade]: ../../Upgrading-Cacti.md
[hardening]: ../../Hardening-Cacti-Installation.md
[windows]: ../../Installing-Under-Windows.md
[windows-upgrade]: ../../Upgrading-Cacti-Under-Windows.md

---

Copyright (c) 2004-2026 The Cacti Group

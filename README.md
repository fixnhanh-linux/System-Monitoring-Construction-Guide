# 🌐 System Monitoring Construction Guide

Tài liệu tổng hợp tư duy và quy trình xây dựng hệ thống giám sát (Monitoring) chuyên nghiệp cho hạ tầng Enterprise.

---

## 🧭 Lộ trình xây dựng (Roadmap)

1. **Giai đoạn 1: Thu thập (Collection)**
   - Xác định Metrics: CPU, RAM, Disk, Network, IOPS, Latency.
   - Chọn phương thức: Pull (Prometheus) hoặc Push (Zabbix/InfluxDB).
   
2. **Giai đoạn 2: Lưu trữ (Storage)**
   - Thiết lập Time Series Database (TSDB).
   - Cấu hình Retention Policy (Lưu trữ ngắn hạn 15 ngày, dài hạn 1 năm).

3. **Giai đoạn 3: Trực quan hóa (Visualization)**
   - Thiết kế Dashboard theo lớp (Layered Dashboard).
   - Tối ưu UI/UX cho người vận hành (NOC).

4. **Giai đoạn 4: Cảnh báo (Alerting)**
   - Phân cấp mức độ: `Information` -> `Warning` -> `Average` -> `High` -> `Disaster`.
   - Kết nối đa kênh: Telegram, Slack, Email, Call API.



---

## 🏛️ Kiến trúc chuẩn (Standard Architecture)

Hệ thống được vận hành dựa trên 3 trụ cột chính:

### 1. Monitoring (Thông số)
Giám sát trạng thái hoạt động của thiết bị phần cứng (Dell, HP, Cisco) và ảo hóa (VMware, Proxmox).
* **Tools:** Prometheus, Zabbix, SNMP.

### 2. Logging (Nhật ký)
Theo dõi hành vi người dùng và lỗi phần mềm (Nginx logs, PHP-FPM error logs).
* **Tools:** ELK Stack (Elasticsearch, Logstash, Kibana) hoặc Loki.

### 3. Tracing (Dấu vết)
Theo dõi luồng xử lý của ứng dụng (Microservices).
* **Tools:** Jaeger, Tempo.

---

## 📊 Dashboard Hierarchy (Phân tầng hiển thị)

Một hệ thống "đẹp" và hiệu quả cần chia làm 3 cấp độ nhìn:

| Cấp độ | Đối tượng | Mục tiêu |
| :--- | :--- | :--- |
| **Executive** | Manager / CTO | Cái nhìn tổng quát về sức khỏe hệ thống (%) |
| **Operational** | NOC Team | Cảnh báo thời gian thực, sự cố đang diễn ra |
| **Technical** | Sysadmin / Dev | Chi tiết thông số để Troubleshooting (Fix lỗi) |



---

## 📝 Best Practices & Tips

* **Naming Convention:** Đặt tên Host/Service thống nhất theo khu vực hoặc chức năng (Ví dụ: `VN-HCM-WEB-01`).
* **Threshold Optimization:** Tránh "Spam Alert". Chỉ cảnh báo khi thực sự cần can thiệp.
* **Auto Discovery:** Tự động quét và thêm thiết bị mới vào hệ thống giám sát.
* **Security:** Luôn chạy Monitoring qua mạng nội bộ (VPN/VLAN riêng) và bật 2FA cho tài khoản admin.

---

## 🔗 Tài liệu tham khảo
* [Prometheus Documentation](https://prometheus.io/docs/)
* [Grafana Dashboards Library](https://grafana.com/grafana/dashboards/)
* [Zabbix Templates Share](https://share.zabbix.com/)

---
⭐ **Nếu bạn thấy tài liệu này hữu ích, hãy tặng mình 1 Star nhé!**
☕ **Ủng hộ ly cafe tại:** `Momo/Banking - 0xxx.xxx.xxx`

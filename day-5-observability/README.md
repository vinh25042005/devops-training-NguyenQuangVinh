## Task: `Day 5 — Observability Basics`

- **Intern**: `Nguyễn Quang Vinh`
- **Phase / Week / Day**: `Phase 1 / Week 2 / Day 5`
- **Branch**: `phase-1/week-2/day-5-observability`
- **Submitted at**: `<2026-06-29 15:30>` (timezone +07)
- **Time spent**: `<5h>`

## 1. Mục tiêu

- Hiểu và phân biệt được **Log vs Metric vs Trace**
- Hiểu **SLI / SLO / SLA** và **Cardinality nổ**
- Thực hành dựng Docker Compose : Prometheus + Grafana + Node Exporter + Blackbox Exporter
- Tìm hiểu alert 

## 2. Cách chạy
### Steps

```bash
cd day-5-observability
docker compose up -d
docker compose ps

```

### Grafana Setup

1. Login `admin / admin` 
2. **Connections → Data sources → Add Prometheus**
3. URL: `http://prometheus:9090` 

## 3. Kết quả
- Stack up bằng 1 lệnh docker compose
- Grafana đã hiện cái metric từ node-exporter
- Đã test dashboard JSON import lại được

## 4. Self-check

- [x] Docker compose up -d chạy được (4 containers Up)
- [x] Prometheus targets UP (node-exporter, blackbox-http)
- [x] Dashboard có 4 panels dữ liệu đầy đủ
- [x] README có hướng dẫn run lại
- [x] Đã review lại code
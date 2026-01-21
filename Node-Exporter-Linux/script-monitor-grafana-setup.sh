
#!/bin/bash

show_menu() {
    echo "=========================================="
    echo "       MENU QUAN LY NODE EXPORTER"
    echo "=========================================="
    echo "1. Cai dat Node Exporter (Co tuy chon SSH)"
    echo "2. Kiem tra Port 9100 & Service"
    echo "3. Go cai dat (Uninstall)"
    echo "4. Thoat va tu xoa Script"
    echo "=========================================="
    read -p "Chon chuc nang [1-4]: " choice
}

install_node() {
    read -p "Nhap phien ban muon cai (VD: 1.7.0): " VERSION
    if [ -z "$VERSION" ]; then echo "Loi: Version trong!"; return; fi

    echo "--- Dang tai va cai dat Node Exporter v$VERSION ---"
    wget https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-amd64.tar.gz
    tar xvf node_exporter-$VERSION.linux-amd64.tar.gz > /dev/null
    sudo mv node_exporter-$VERSION.linux-amd64/node_exporter /usr/local/bin/
    rm -rf node_exporter-$VERSION.linux-amd64*

    sudo useradd -rs /bin/false node_exporter || true
    cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable --now node_exporter
    echo "✅ Da cai xong Node Exporter tai cho."

    echo "------------------------------------------"
    read -p "Ban co muon cau hinh SSH sang Prometheus ko? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        read -p "Nhap IP Prometheus: " P_IP
        read -p "Nhap User SSH (mac dinh root): " P_USER
        P_USER=${P_USER:-root}
        LOCAL_IP=$(hostname -I | awk '{print $1}')

        echo "--- Dang ket noi den $P_IP ---"
        # Su dung tham so -t de cap terminal neu can
        ssh -t ${P_USER}@${P_IP} "sudo bash -c \"echo '  - job_name: node-$(hostname)
    static_configs:
      - targets: [$LOCAL_IP:9100]' >> /etc/prometheus/prometheus.yml && curl -X POST http://localhost:9090/-/reload\""
        
        if [ $? -eq 0 ]; then
            echo "✅ Da cau hinh Prometheus tu xa thanh cong!"
        else
            echo "❌ Loi ket noi SSH. Vui long kiem tra lai IP/Password."
        fi
    else
        echo "Da bo qua buoc cau hinh Prometheus."
    fi
}

check_status() {
    echo "--- KIEM TRA HE THONG ---"
    ss -tuln | grep -q ":9100" && echo "✅ Port 9100: OPEN" || echo "❌ Port 9100: CLOSED"
    systemctl is-active --quiet node_exporter && echo "✅ Service: RUNNING" || echo "❌ Service: STOPPED"
}

uninstall_node() {
    echo "--- DANG GO CAI DAT ---"
    sudo systemctl stop node_exporter
    sudo systemctl disable node_exporter
    sudo rm /etc/systemd/system/node_exporter.service
    sudo rm /usr/local/bin/node_exporter
    sudo userdel node_exporter || true
    echo "✅ Da go bo hoan toan."
}

while true; do
    show_menu
    case $choice in
        1) install_node ;;
        2) check_status ;;
        3) uninstall_node ;;
        4) echo "Tam biet!"; rm -- "$0"; exit 0 ;;
        *) echo "Lua chon sai!" ;;
    esac
    echo ""
    read -p "Nhan Enter de tiep tuc..." temp
    clear
done

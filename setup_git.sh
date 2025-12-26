#!/bin/bash

# Script để setup git và push code lên GitHub
# Chạy: bash setup_git.sh

cd /Users/anhtran/Desktop/portfolio

echo "=== Kiểm tra trạng thái git ==="
git status

echo ""
echo "=== Cấu hình git user ==="
git config user.name "Huy Mai"
git config user.email "dinhhuy2908@gmail.com"

echo ""
echo "=== Kiểm tra SSH key ==="
if [ -f ~/.ssh/id_ed25519.pub ] || [ -f ~/.ssh/id_rsa.pub ]; then
    echo "✓ Đã tìm thấy SSH key"
    if [ -f ~/.ssh/id_ed25519.pub ]; then
        echo "SSH Key (ed25519):"
        cat ~/.ssh/id_ed25519.pub
    else
        echo "SSH Key (rsa):"
        cat ~/.ssh/id_rsa.pub
    fi
    echo ""
    echo "Nếu chưa thêm key vào GitHub, copy key trên và thêm vào:"
    echo "https://github.com/settings/ssh/new"
else
    echo "⚠ Chưa có SSH key. Tạo SSH key mới..."
    ssh-keygen -t ed25519 -C "dinhhuy2908@gmail.com" -f ~/.ssh/id_ed25519 -N ""
    echo ""
    echo "✓ Đã tạo SSH key. Copy key dưới đây và thêm vào GitHub:"
    echo "https://github.com/settings/ssh/new"
    echo ""
    cat ~/.ssh/id_ed25519.pub
    echo ""
    echo "Sau khi thêm key vào GitHub, nhấn Enter để tiếp tục..."
    read
fi

echo ""
echo "=== Đổi remote sang SSH ==="
git remote set-url origin git@github.com:dinhhuy2908/portfolio.git
git remote -v

echo ""
echo "=== Test SSH connection ==="
ssh -T git@github.com

echo ""
echo "=== Add và commit thay đổi ==="
git add .
git status

echo ""
read -p "Nhập commit message (hoặc Enter để dùng message mặc định): " commit_msg
if [ -z "$commit_msg" ]; then
    commit_msg="Update portfolio content for Huy Mai - Quality & Delivery Leader"
fi
git commit -m "$commit_msg"

echo ""
echo "=== Push lên GitHub ==="
git push origin main

echo ""
echo "✓ Hoàn thành!"


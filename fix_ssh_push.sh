#!/bin/bash

# Script để fix lỗi SSH và push code
cd /Users/anhtran/Desktop/portfolio

echo "=== Bước 1: Kiểm tra SSH key ==="
if [ -f ~/.ssh/id_ed25519.pub ]; then
    echo "✓ Tìm thấy SSH key"
    echo ""
    echo "=== SSH Public Key của bạn ==="
    cat ~/.ssh/id_ed25519.pub
    echo ""
    echo "=== Nếu chưa thêm key vào GitHub, làm theo các bước sau: ==="
    echo "1. Copy toàn bộ key ở trên (bắt đầu bằng ssh-ed25519...)"
    echo "2. Mở trình duyệt và vào: https://github.com/settings/ssh/new"
    echo "3. Paste key vào ô 'Key'"
    echo "4. Đặt title: 'Portfolio Mac'"
    echo "5. Click 'Add SSH key'"
    echo ""
    read -p "Đã thêm key vào GitHub chưa? (y/n): " added_key
    
    if [ "$added_key" != "y" ]; then
        echo "Vui lòng thêm key vào GitHub trước khi tiếp tục!"
        exit 1
    fi
else
    echo "⚠ Không tìm thấy SSH key. Tạo mới..."
    ssh-keygen -t ed25519 -C "dinhhuy2908@gmail.com" -f ~/.ssh/id_ed25519 -N ""
    echo ""
    echo "=== SSH Public Key mới ==="
    cat ~/.ssh/id_ed25519.pub
    echo ""
    echo "Vui lòng thêm key này vào GitHub: https://github.com/settings/ssh/new"
    read -p "Nhấn Enter sau khi đã thêm key..."
fi

echo ""
echo "=== Bước 2: Start ssh-agent và add key ==="
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

echo ""
echo "=== Bước 3: Test SSH connection ==="
ssh -T git@github.com

echo ""
echo "=== Bước 4: Kiểm tra remote ==="
git remote -v

echo ""
echo "=== Bước 5: Đảm bảo remote dùng SSH ==="
git remote set-url origin git@github.com:dinhhuy2908/portfolio.git
git remote -v

echo ""
echo "=== Bước 6: Add và commit thay đổi ==="
git add .
git status

echo ""
read -p "Nhập commit message (hoặc Enter để dùng mặc định): " commit_msg
if [ -z "$commit_msg" ]; then
    commit_msg="Update portfolio content for Huy Mai - Quality & Delivery Leader"
fi

git commit -m "$commit_msg"

echo ""
echo "=== Bước 7: Push lên GitHub ==="
git push origin main

echo ""
echo "✓ Hoàn thành!"


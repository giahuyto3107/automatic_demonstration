# Automatic Demonstration (Street Voice App)

Dự án Flutter hướng dẫn âm thanh dựa trên vị trí địa lý (Street Voice).

## 🚀 Các chức năng đã triển khai gần đây

Dưới đây là tóm tắt các tính năng và công việc đã được hoàn thiện:

- **Tích hợp API Thực Tế (Fetch API)**: 
  - Khởi tạo chức năng gọi API kết nối với Backend để lấy danh sách các quán ăn (Food Stalls).
  - Khởi tạo thư mục `service` và `network` để quản lý luồng dữ liệu mạng tập trung.
  - Cấu hình bảo mật API Key bằng biến môi trường qua file `.env`.

- **Chế độ Sáng / Tối (Dark / Light Mode)**: 
  - Thêm chức năng Switch/Toggle Button cho phép người dùng chuyển đổi linh hoạt giữa giao diện Sáng và Tối.

- **Quản Lý Trạng Thái (State Management)**: 
  - Tích hợp các bộ Provider quản lý trạng thái cho toàn ứng dụng bao gồm: `Food Stall Model`, `Locale`, và `Theme Provider`.

- **Cập Nhật Vị Trí (GPS Locator)**: 
  - Bổ sung nút làm mới (Refresh Button) cho phép lấy lại tọa độ địa lý GPS mới nhất của thiết bị.

- **Tinh chỉnh giao diện (UI/UX)**:
  - Cập nhật Widget hiển thị cửa hàng (Food Stall List Section).
  - Tối ưu UI (Padding, Spacing) cho các action buttons.
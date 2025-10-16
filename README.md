# 🛍️ Single Vendor eCommerce Website (Ruby on Rails)

A full-featured **Single-Vendor eCommerce Platform** built with **Ruby on Rails**.  
It provides a **modern shopping experience** for customers and a **powerful admin panel** for managing products, categories, users, and orders — all from one dashboard.

---

## 🚀 Features

### 🛒 Storefront (User Side)
- Responsive and mobile-friendly design
- Product browsing and filtering
- Add to cart and checkout
- Order tracking
- Secure user registration and login (Devise)
- Email confirmations and notifications

### ⚙️ Admin Panel
- Dashboard with sales and order insights
- Manage products, categories, and users
- Order management (view, update status, delete)
- Inventory tracking
- View sales reports
- Role-based access (admin vs. customer)

---

## 🧩 Tech Stack

| Layer | Technology |
|-------|-------------|
| **Framework** | Ruby on Rails 7+ |
| **Frontend** | ERB / Turbo / Stimulus / Bootstrap / Tailwind CSS |
| **Database** | MySQL / PostgreSQL |
| **Authentication** | Devise |
| **Authorization** | CanCanCan |
| **File Storage** | Active Storage (local / AWS S3) |
| **Background Jobs** | Sidekiq / Delayed Job |
| **Payments** | Stripe / Razorpay (optional) |
| **Admin Interface** | Rails Admin / ActiveAdmin |

---

## ⚙️ Installation & Setup

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/your-username/ecommerce-rails.git
cd ecommerce-rails

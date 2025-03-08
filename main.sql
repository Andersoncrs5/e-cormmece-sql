CREATE TYPE status_sale_enum AS ENUM ('pending_payment', 'payment_completed', 'cancelled', 'refused');
CREATE TYPE status_shipping_enum AS ENUM ('pending_payment', 'processing', 'shipped', 'delivered', 'returned', 'cancelled');
CREATE TYPE log_type_enum AS ENUM ('info', 'warning', 'error', 'debug');
CREATE TYPE role_user AS ENUM ('customer', 'admin');
CREATE TYPE status_support_enum AS ENUM ('open', 'in_progress', 'resolved', 'closed');

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(300) NOT NULL,
    role role_user NOT NULL,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    updatedAt TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE TABLE address (
    id BIGSERIAL PRIMARY KEY,
    zip_code VARCHAR(20),
    number_house INTEGER NOT NULL,
    street VARCHAR(150) NOT NULL,
    neighborhood VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(150) NOT NULL,
    country VARCHAR(150) NOT NULL,
    complement VARCHAR(300),
    userId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    updatedAt TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    image VARCHAR(300) NOT NULL,
    content TEXT NOT NULL,
    quantity INTEGER DEFAULT 0 NOT NULL,
    sold INTEGER DEFAULT 0 NOT NULL,
    is_active BOOLEAN DEFAULT FALSE,
    viewed INTEGER DEFAULT 0 NOT NULL,
    unique_code INTEGER NOT NULL UNIQUE,
    price NUMERIC(10,2) NOT NULL,
    note NUMERIC(3,1) DEFAULT 0.0 NOT NULL,
    category VARCHAR(150) NOT NULL,
    userId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    updatedAt TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    is_active BOOLEAN DEFAULT FALSE,
    userId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    updatedAt TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE comments (
    id BIGSERIAL PRIMARY KEY,
    content VARCHAR(500) NOT NULL,
    is_edited BOOLEAN DEFAULT FALSE,
    userId BIGINT NOT NULL,
    productId BIGINT NOT NULL,
    parent_id BIGINT,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_product FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_parent_comment FOREIGN KEY (parent_id) REFERENCES comments(id) ON DELETE CASCADE
);

CREATE TABLE favorite (
    id BIGSERIAL PRIMARY KEY,
    userId BIGINT NOT NULL,
    productId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_product FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE cart (
    id BIGSERIAL PRIMARY KEY,
    userId BIGINT NOT NULL,
    productId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_product FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    userId BIGINT NOT NULL,
    productId BIGINT NOT NULL,
    quantity INTEGER DEFAULT 1 NOT NULL,
    value NUMERIC(5,2) NOT NULL,
    sale_status status_sale_enum DEFAULT 'pending_payment' NOT NULL,
    shipping_status status_shipping_enum DEFAULT 'pending_payment' NOT NULL,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_product FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE logs (
    id BIGSERIAL PRIMARY KEY,
    userId BIGINT,
    action VARCHAR(255) NOT NULL,
    log_type log_type_enum NOT NULL,
    message TEXT NOT NULL,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    updatedAt TIMESTAMP DEFAULT NOW() NOT NULL,
    ip_address VARCHAR(50),
    user_agent VARCHAR(255),
    CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE discount_coupons (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(100) UNIQUE NOT NULL,
    description VARCHAR(255) NOT NULL,
    discount_percentage NUMERIC(5,2) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_until TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    used_count INTEGER DEFAULT 0 NOT NULL,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    updatedAt TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE TABLE product_reviews (
    id BIGSERIAL PRIMARY KEY,
    productId BIGINT NOT NULL,
    userId BIGINT NOT NULL,
    rating NUMERIC(2,1) NOT NULL,
    comment TEXT,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT fk_product FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE shipping (
    id BIGSERIAL PRIMARY KEY,
    orderId BIGINT NOT NULL,
    shipping_address VARCHAR(255) NOT NULL,
    shipping_method VARCHAR(50) NOT NULL,
    tracking_number VARCHAR(100),
    status status_shipping_enum DEFAULT 'pending' NOT NULL,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    updatedAt TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT fk_order FOREIGN KEY (orderId) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE TABLE customer_support (
    id BIGSERIAL PRIMARY KEY,
    userId BIGINT NOT NULL,
    issue_description TEXT NOT NULL,
    status status_support_enum DEFAULT 'open' NOT NULL,
    resolvedAt TIMESTAMP,
    createdAt TIMESTAMP DEFAULT NOW() NOT NULL,
    updatedAt TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
);

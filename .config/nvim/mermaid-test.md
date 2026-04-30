# Mermaid Diagram Test

## Flowchart

```mermaid
flowchart TD
    A[User Request] --> B{Authenticated?}
    B -- Yes --> C[API Gateway]
    B -- No --> D[Login Page]
    C --> E[Service A]
    C --> F[Service B]
    E --> G[(Database)]
    F --> G
```

## Sequence Diagram

```mermaid
xychart-beta
    title Monthly Revenue (USD)
    x-axis [Jan, Feb, Mar, Apr, May, Jun]
    y-axis "Revenue" 0 --> 50000
    bar  [12000, 18000, 15000, 22000, 30000, 28000]
    line [12000, 18000, 15000, 22000, 30000, 28000]
```

```mermaid
sequenceDiagram
    actor User
    participant FE as Frontend
    participant API as API Gateway
    participant Auth as Auth Service
    participant DB as Database

    User->>FE: Submit login form
    FE->>API: POST /auth/login
    API->>Auth: Validate credentials
    Auth->>DB: Query user
    DB-->>Auth: User record
    Auth-->>API: JWT token
    API-->>FE: 200 OK + token
    FE-->>User: Redirect to dashboard
```

## Class Diagram

```mermaid
classDiagram
    class Animal {
        +String name
        +int age
        +makeSound() void
    }
    class Dog {
        +String breed
        +fetch() void
    }
    class Cat {
        +bool isIndoor
        +purr() void
    }
    Animal <|-- Dog
    Animal <|-- Cat
```

## ER Diagram

```mermaid
erDiagram
    USER {
        int id PK
        string email
        string name
        timestamp created_at
    }
    ORDER {
        int id PK
        int user_id FK
        float total
        string status
    }
    ORDER_ITEM {
        int id PK
        int order_id FK
        int product_id FK
        int quantity
    }
    PRODUCT {
        int id PK
        string name
        float price
    }

    USER ||--o{ ORDER : places
    ORDER ||--|{ ORDER_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : "referenced by"
```

## State Diagram

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Processing : submit
    Processing --> Success : ok
    Processing --> Failed : error
    Failed --> Idle : retry
    Success --> [*]
```

## C4 Context Diagram

```mermaid
C4Context
    title System Context — E-Commerce Platform

    Person(customer, "Customer", "A person buying stuff")
    Person(admin, "Admin", "Manages inventory and orders")

    System(platform, "E-Commerce Platform", "Handles orders, payments, inventory")

    System_Ext(payment, "Payment Gateway", "Stripe / PayPal")
    System_Ext(email, "Email Service", "SendGrid")
    System_Ext(shipping, "Shipping API", "FedEx / UPS")

    Rel(customer, platform, "Browses and orders", "HTTPS")
    Rel(admin, platform, "Manages", "HTTPS")
    Rel(platform, payment, "Charges cards", "HTTPS/API")
    Rel(platform, email, "Sends receipts", "SMTP")
    Rel(platform, shipping, "Books shipments", "API")
```

## C4 Container Diagram

```mermaid
C4Container
    title Container Diagram — E-Commerce Platform

    Person(customer, "Customer")

    Container_Boundary(platform, "E-Commerce Platform") {
        Container(spa, "Web App", "React", "Customer-facing UI")
        Container(api, "API", "Go", "Business logic and REST API")
        Container(worker, "Worker", "Go", "Async job processing")
        ContainerDb(db, "Database", "PostgreSQL", "Orders, users, products")
        ContainerDb(cache, "Cache", "Redis", "Sessions and rate limiting")
    }

    System_Ext(payment, "Payment Gateway")

    Rel(customer, spa, "Uses", "HTTPS")
    Rel(spa, api, "Calls", "REST/JSON")
    Rel(api, db, "Reads/writes")
    Rel(api, cache, "Reads/writes")
    Rel(api, worker, "Enqueues jobs", "Redis queue")
    Rel(api, payment, "Charges", "HTTPS")
```

## Gantt Chart

```mermaid
gantt
    title Project Roadmap Q2
    dateFormat  YYYY-MM-DD
    section Backend
    Auth service       :done,    a1, 2025-04-01, 2025-04-10
    API gateway        :active,  a2, 2025-04-10, 2025-04-25
    Worker service     :         a3, 2025-04-25, 2025-05-10
    section Frontend
    Login flow         :done,    f1, 2025-04-05, 2025-04-15
    Dashboard          :active,  f2, 2025-04-15, 2025-05-01
    Admin panel        :         f3, 2025-05-01, 2025-05-20
```

## Git Graph

```mermaid
gitGraph
    commit id: "init"
    branch feature/auth
    checkout feature/auth
    commit id: "add login"
    commit id: "add JWT"
    checkout main
    merge feature/auth id: "merge auth"
    branch feature/api
    checkout feature/api
    commit id: "add endpoints"
    checkout main
    merge feature/api id: "merge api"
    commit id: "release v1.0"
```

## Pie Chart

```mermaid
pie title API Traffic by Service
    "Auth" : 15
    "Orders" : 35
    "Products" : 28
    "Users" : 12
    "Other" : 10
```

## Quadrant Chart

```mermaid
quadrantChart
    title Feature Priority Matrix
    x-axis Low Effort --> High Effort
    y-axis Low Impact --> High Impact
    quadrant-1 Do First
    quadrant-2 Plan
    quadrant-3 Reconsider
    quadrant-4 Fill-in
    Dark mode: [0.2, 0.8]
    SSO login: [0.6, 0.9]
    CSV export: [0.3, 0.4]
    Mobile app: [0.9, 0.7]
    Analytics: [0.7, 0.6]
    Tooltips: [0.15, 0.3]
```

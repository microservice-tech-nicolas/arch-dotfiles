local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- All snippets are prefixed with "mm" (mermaid) to avoid conflicts.
-- Expand with your completion key. Cursor lands after the closing fence.

return {

  -- ─── Flowchart ────────────────────────────────────────────────────────────
  -- mmflow
  s("mmflow", {
    t({
      "```mermaid",
      "flowchart TD",
      "    A[Start] --> B{Decision?}",
      "    B -- Yes --> C[Do something]",
      "    B -- No  --> D[Do other thing]",
      "    C --> E[End]",
      "    D --> E",
      "```",
    }),
    i(0),
  }),

  -- mmflowlr  (left-to-right variant)
  s("mmflowlr", {
    t({
      "```mermaid",
      "flowchart LR",
      "    A[Client] --> B[API Gateway]",
      "    B --> C[Service A]",
      "    B --> D[Service B]",
      "    C --> E[(Database)]",
      "    D --> E",
      "```",
    }),
    i(0),
  }),

  -- ─── Sequence Diagram ─────────────────────────────────────────────────────
  -- mmseq
  s("mmseq", {
    t({
      "```mermaid",
      "sequenceDiagram",
      "    actor User",
      "    participant FE as Frontend",
      "    participant API",
      "    participant DB",
      "",
      "    User->>FE: Action",
      "    FE->>API: Request",
      "    API->>DB: Query",
      "    DB-->>API: Result",
      "    API-->>FE: Response",
      "    FE-->>User: Update UI",
      "```",
    }),
    i(0),
  }),

  -- mmseqloop  (with loop, alt, opt blocks)
  s("mmseqloop", {
    t({
      "```mermaid",
      "sequenceDiagram",
      "    participant A",
      "    participant B",
      "",
      "    loop Every minute",
      "        A->>B: Heartbeat ping",
      "        B-->>A: Pong",
      "    end",
      "",
      "    alt Success",
      "        A->>B: Proceed",
      "    else Failure",
      "        A->>B: Abort",
      "    end",
      "",
      "    opt Optional step",
      "        A->>B: Extra call",
      "    end",
      "```",
    }),
    i(0),
  }),

  -- ─── Class Diagram ────────────────────────────────────────────────────────
  -- mmclass
  s("mmclass", {
    t({
      "```mermaid",
      "classDiagram",
      "    class Animal {",
      "        +String name",
      "        +int age",
      "        +makeSound() void",
      "    }",
      "    class Dog {",
      "        +String breed",
      "        +fetch() void",
      "    }",
      "    class Cat {",
      "        +bool indoor",
      "        +purr() void",
      "    }",
      "",
      "    Animal <|-- Dog  : extends",
      "    Animal <|-- Cat  : extends",
      "    Dog o-- Cat      : knows",
      "```",
    }),
    i(0),
  }),

  -- ─── State Diagram ────────────────────────────────────────────────────────
  -- mmstate
  s("mmstate", {
    t({
      "```mermaid",
      "stateDiagram-v2",
      "    [*] --> Idle",
      "",
      "    Idle --> Processing : submit",
      "    Processing --> Success : ok",
      "    Processing --> Failed  : error",
      "    Failed --> Idle       : retry",
      "    Success --> [*]",
      "```",
    }),
    i(0),
  }),

  -- mmstatecomp  (with composite / nested states)
  s("mmstatecomp", {
    t({
      "```mermaid",
      "stateDiagram-v2",
      "    [*] --> Active",
      "",
      "    state Active {",
      "        [*] --> Connecting",
      "        Connecting --> Connected : handshake ok",
      "        Connected --> Disconnected : timeout",
      "        Disconnected --> [*]",
      "    }",
      "",
      "    Active --> Stopped : shutdown",
      "    Stopped --> [*]",
      "```",
    }),
    i(0),
  }),

  -- ─── ER Diagram ───────────────────────────────────────────────────────────
  -- mmer
  s("mmer", {
    t({
      "```mermaid",
      "erDiagram",
      "    USER {",
      "        int    id        PK",
      "        string email",
      "        string name",
      "    }",
      "    ORDER {",
      "        int    id        PK",
      "        int    user_id   FK",
      "        float  total",
      "        string status",
      "    }",
      "    ORDER_ITEM {",
      "        int id         PK",
      "        int order_id   FK",
      "        int product_id FK",
      "        int quantity",
      "    }",
      "    PRODUCT {",
      "        int    id    PK",
      "        string name",
      "        float  price",
      "    }",
      "",
      "    USER     ||--o{ ORDER      : places",
      "    ORDER    ||--|{ ORDER_ITEM  : contains",
      "    PRODUCT  ||--o{ ORDER_ITEM  : \"referenced by\"",
      "```",
    }),
    i(0),
  }),

  -- ─── Gantt ────────────────────────────────────────────────────────────────
  -- mmgantt
  s("mmgantt", {
    t({
      "```mermaid",
      "gantt",
      "    title Project Roadmap",
      "    dateFormat YYYY-MM-DD",
      "    excludes weekends",
      "",
      "    section Backend",
      "    Auth service     :done,   b1, 2025-01-01, 2025-01-14",
      "    API endpoints    :active, b2, 2025-01-14, 2025-01-28",
      "    Worker service   :        b3, after b2, 14d",
      "",
      "    section Frontend",
      "    Login flow       :done,   f1, 2025-01-07, 10d",
      "    Dashboard        :active, f2, after f1, 14d",
      "    Admin panel      :        f3, after f2, 10d",
      "```",
    }),
    i(0),
  }),

  -- ─── Pie Chart ────────────────────────────────────────────────────────────
  -- mmpie
  s("mmpie", {
    t({
      "```mermaid",
      "pie title Traffic by Source",
      "    \"Organic\"  : 42",
      "    \"Direct\"   : 28",
      "    \"Referral\" : 18",
      "    \"Social\"   : 12",
      "```",
    }),
    i(0),
  }),

  -- ─── Git Graph ────────────────────────────────────────────────────────────
  -- mmgit
  s("mmgit", {
    t({
      "```mermaid",
      "gitGraph",
      "    commit id: \"init\"",
      "    branch develop",
      "    checkout develop",
      "    commit id: \"feature work\"",
      "    branch feature/foo",
      "    checkout feature/foo",
      "    commit id: \"add foo\"",
      "    checkout develop",
      "    merge feature/foo",
      "    checkout main",
      "    merge develop id: \"release v1.0\" tag: \"v1.0\"",
      "```",
    }),
    i(0),
  }),

  -- ─── C4 — Context ─────────────────────────────────────────────────────────
  -- mmc4ctx
  s("mmc4ctx", {
    t({
      "```mermaid",
      "C4Context",
      "    title System Context",
      "",
      "    Person(user,    \"User\",    \"A person using the system\")",
      "    Person(admin,   \"Admin\",   \"Manages the system\")",
      "",
      "    System(system, \"My System\", \"Does the thing\")",
      "",
      "    System_Ext(ext1, \"External API\",   \"Third-party service\")",
      "    System_Ext(ext2, \"Email Service\",  \"Sends email\")",
      "",
      "    Rel(user,   system, \"Uses\",         \"HTTPS\")",
      "    Rel(admin,  system, \"Administers\",  \"HTTPS\")",
      "    Rel(system, ext1,   \"Calls\",        \"REST\")",
      "    Rel(system, ext2,   \"Sends via\",    \"SMTP\")",
      "```",
    }),
    i(0),
  }),

  -- ─── C4 — Container ───────────────────────────────────────────────────────
  -- mmc4con
  s("mmc4con", {
    t({
      "```mermaid",
      "C4Container",
      "    title Container Diagram",
      "",
      "    Person(user, \"User\")",
      "",
      "    Container_Boundary(sys, \"My System\") {",
      "        Container(web,    \"Web App\",  \"React\",      \"User interface\")",
      "        Container(api,    \"API\",       \"Go\",         \"Business logic\")",
      "        Container(worker, \"Worker\",   \"Go\",         \"Async jobs\")",
      "        ContainerDb(db,   \"Database\", \"PostgreSQL\", \"Persistent data\")",
      "        ContainerDb(cache,\"Cache\",    \"Redis\",      \"Sessions\")",
      "    }",
      "",
      "    System_Ext(ext, \"External Service\")",
      "",
      "    Rel(user,   web,    \"Uses\",        \"HTTPS\")",
      "    Rel(web,    api,    \"Calls\",        \"REST/JSON\")",
      "    Rel(api,    db,     \"Reads/writes\")",
      "    Rel(api,    cache,  \"Reads/writes\")",
      "    Rel(api,    worker, \"Enqueues\",     \"Queue\")",
      "    Rel(api,    ext,    \"Calls\",        \"HTTPS\")",
      "```",
    }),
    i(0),
  }),

  -- ─── C4 — Component ───────────────────────────────────────────────────────
  -- mmc4comp
  s("mmc4comp", {
    t({
      "```mermaid",
      "C4Component",
      "    title Component Diagram — API",
      "",
      "    Container(web, \"Web App\", \"React\")",
      "",
      "    Container_Boundary(api, \"API\") {",
      "        Component(router,  \"Router\",         \"Go\", \"Routes requests\")",
      "        Component(auth,    \"Auth Middleware\", \"Go\", \"Validates JWT\")",
      "        Component(handler, \"Order Handler\",  \"Go\", \"Order logic\")",
      "        Component(repo,    \"Repository\",     \"Go\", \"DB access\")",
      "    }",
      "",
      "    ContainerDb(db, \"Database\", \"PostgreSQL\")",
      "",
      "    Rel(web,     router,  \"Calls\",   \"REST\")",
      "    Rel(router,  auth,    \"Passes through\")",
      "    Rel(auth,    handler, \"Forwards\")",
      "    Rel(handler, repo,    \"Uses\")",
      "    Rel(repo,    db,      \"Queries\")",
      "```",
    }),
    i(0),
  }),

  -- ─── C4 — Deployment ──────────────────────────────────────────────────────
  -- mmc4dep
  s("mmc4dep", {
    t({
      "```mermaid",
      "C4Deployment",
      "    title Deployment Diagram",
      "",
      "    Deployment_Node(cloud, \"AWS\", \"Cloud\") {",
      "        Deployment_Node(vpc, \"VPC\") {",
      "            Deployment_Node(ec2, \"EC2\", \"t3.medium\") {",
      "                Container(api, \"API\", \"Go\", \"Business logic\")",
      "            }",
      "            Deployment_Node(rds, \"RDS\", \"PostgreSQL 15\") {",
      "                ContainerDb(db, \"Database\", \"PostgreSQL\")",
      "            }",
      "        }",
      "    }",
      "",
      "    Deployment_Node(cdn, \"CloudFront\", \"CDN\") {",
      "        Container(web, \"Web App\", \"React\")",
      "    }",
      "",
      "    Rel(web, api, \"Calls\", \"HTTPS\")",
      "    Rel(api, db,  \"Reads/writes\")",
      "```",
    }),
    i(0),
  }),

  -- ─── Mindmap ──────────────────────────────────────────────────────────────
  -- mmmind
  s("mmmind", {
    t({
      "```mermaid",
      "mindmap",
      "    root((Project))",
      "        Backend",
      "            API",
      "            Database",
      "            Auth",
      "        Frontend",
      "            Web",
      "            Mobile",
      "        Infrastructure",
      "            CI/CD",
      "            Monitoring",
      "            Cloud",
      "```",
    }),
    i(0),
  }),

  -- ─── Timeline ─────────────────────────────────────────────────────────────
  -- mmtime
  s("mmtime", {
    t({
      "```mermaid",
      "timeline",
      "    title Product History",
      "    section 2023",
      "        Q1 : MVP launched",
      "           : First 100 users",
      "        Q3 : Series A funding",
      "    section 2024",
      "        Q1 : Mobile app released",
      "        Q2 : 10k users milestone",
      "        Q4 : Enterprise tier launched",
      "    section 2025",
      "        Q1 : International expansion",
      "```",
    }),
    i(0),
  }),

  -- ─── Quadrant Chart ───────────────────────────────────────────────────────
  -- mmquad
  s("mmquad", {
    t({
      "```mermaid",
      "quadrantChart",
      "    title Feature Priority Matrix",
      "    x-axis Low Effort --> High Effort",
      "    y-axis Low Impact --> High Impact",
      "    quadrant-1 Do First",
      "    quadrant-2 Schedule",
      "    quadrant-3 Reconsider",
      "    quadrant-4 Fill-in",
      "    Dark mode:       [0.2, 0.8]",
      "    SSO login:       [0.6, 0.9]",
      "    CSV export:      [0.3, 0.4]",
      "    Mobile app:      [0.9, 0.7]",
      "    Analytics:       [0.7, 0.6]",
      "    Tooltip support: [0.15, 0.3]",
      "```",
    }),
    i(0),
  }),

  -- ─── XY Chart (requires Mermaid v10.6+) ──────────────────────────────────
  -- mmxy
  s("mmxy", {
    t({
      "```mermaid",
      "xychart-beta",
      "    title Monthly Revenue (USD)",
      "    x-axis [Jan, Feb, Mar, Apr, May, Jun]",
      "    y-axis \"Revenue\" 0 --> 50000",
      "    bar  [12000, 18000, 15000, 22000, 30000, 28000]",
      "    line [12000, 18000, 15000, 22000, 30000, 28000]",
      "```",
    }),
    i(0),
  }),

  -- ─── Block Diagram (requires Mermaid v10.8+) ──────────────────────────────
  -- mmblock
  s("mmblock", {
    t({
      "```mermaid",
      "block-beta",
      "    columns 3",
      "    A[\"Load Balancer\"]  B[\"App Server 1\"]  C[\"App Server 2\"]",
      "    space              D[(\"Database\")]     space",
      "    space              E[\"Cache\"]          space",
      "",
      "    A --> B",
      "    A --> C",
      "    B --> D",
      "    C --> D",
      "    B --> E",
      "    C --> E",
      "```",
    }),
    i(0),
  }),

  -- ─── User Journey ─────────────────────────────────────────────────────────
  -- mmjourney
  s("mmjourney", {
    t({
      "```mermaid",
      "journey",
      "    title User Checkout Flow",
      "    section Browse",
      "        Visit site:      5: User",
      "        Search product:  4: User",
      "        View details:    4: User",
      "    section Purchase",
      "        Add to cart:     5: User",
      "        Enter payment:   3: User",
      "        Confirm order:   5: User, System",
      "    section Post-purchase",
      "        Receive email:   4: System",
      "        Track shipment:  3: User",
      "```",
    }),
    i(0),
  }),

  -- ─── Sankey (requires Mermaid v10.3+) ────────────────────────────────────
  -- mmsankey
  s("mmsankey", {
    t({
      "```mermaid",
      "sankey-beta",
      "",
      "    %% source,target,value",
      "    Revenue,Product A,40",
      "    Revenue,Product B,30",
      "    Revenue,Product C,30",
      "    Product A,COGS,20",
      "    Product A,Gross Profit,20",
      "    Product B,COGS,15",
      "    Product B,Gross Profit,15",
      "    Product C,COGS,10",
      "    Product C,Gross Profit,20",
      "    Gross Profit,Operating Costs,25",
      "    Gross Profit,Net Income,30",
      "```",
    }),
    i(0),
  }),

  -- ─── Requirement Diagram ──────────────────────────────────────────────────
  -- mmreq
  s("mmreq", {
    t({
      "```mermaid",
      "requirementDiagram",
      "",
      "    requirement auth_req {",
      "        id: 1",
      "        text: The system shall authenticate users via JWT.",
      "        risk: high",
      "        verifymethod: test",
      "    }",
      "",
      "    functionalRequirement api_req {",
      "        id: 2",
      "        text: The API shall respond within 200ms.",
      "        risk: medium",
      "        verifymethod: demonstration",
      "    }",
      "",
      "    element login_service {",
      "        type: service",
      "        docref: services/auth.md",
      "    }",
      "",
      "    login_service - satisfies -> auth_req",
      "    login_service - satisfies -> api_req",
      "```",
    }),
    i(0),
  }),

  -- ─── Architecture Diagram (requires Mermaid v11.1+) ──────────────────────
  -- mmarch
  s("mmarch", {
    t({
      "```mermaid",
      "architecture-beta",
      "    group cloud(cloud)[Cloud]",
      "",
      "    service cdn(internet)[CDN] in cloud",
      "    service api(server)[API Server] in cloud",
      "    service db(database)[Database] in cloud",
      "    service queue(server)[Message Queue] in cloud",
      "    service worker(server)[Worker] in cloud",
      "",
      "    cdn:R --> L:api",
      "    api:R --> L:db",
      "    api:B --> T:queue",
      "    queue:R --> L:worker",
      "    worker:B --> T:db",
      "```",
    }),
    i(0),
  }),

  -- ─── Packet Diagram (requires Mermaid v11+) ───────────────────────────────
  -- mmpacket
  s("mmpacket", {
    t({
      "```mermaid",
      "packet-beta",
      "    title TCP Header",
      "    0-15: \"Source Port\"",
      "    16-31: \"Destination Port\"",
      "    32-63: \"Sequence Number\"",
      "    64-95: \"Acknowledgment Number\"",
      "    96-99: \"Data Offset\"",
      "    100-105: \"Reserved\"",
      "    106: \"URG\"",
      "    107: \"ACK\"",
      "    108: \"PSH\"",
      "    109: \"RST\"",
      "    110: \"SYN\"",
      "    111: \"FIN\"",
      "    112-127: \"Window Size\"",
      "```",
    }),
    i(0),
  }),

  -- ─── ZenUML (code-style sequence) ────────────────────────────────────────
  -- mmzenuml
  s("mmzenuml", {
    t({
      "```mermaid",
      "zenuml",
      "    title Order Flow",
      "    @Actor User",
      "    @Boundary FE",
      "    @Control API",
      "    @Database DB",
      "",
      "    User -> FE.submit() {",
      "        FE -> API.createOrder() {",
      "            API -> DB.insert()",
      "            return orderId",
      "        }",
      "        return confirmation",
      "    }",
      "```",
    }),
    i(0),
  }),

}


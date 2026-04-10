# Flutter Layout Architecture Cheat Sheet

## Production-Level Guide for Real-World Apps

---

## 1. CORE LAYOUT WIDGETS: When to Use What

### Column vs Row: The Foundation

**Column** - Vertical stacking

```dart
// ✅ DO: Use when content flows vertically
Column(
  mainAxisSize: MainAxisSize.min, // Shrink-wrap by default
  crossAxisAlignment: CrossAxisAlignment.start, // Align children
  children: [
    Text('Title'),
    Text('Subtitle'),
    ElevatedButton(onPressed: () {}, child: Text('Action')),
  ],
)

// ❌ DON'T: Use Column when you need scrolling
Column(
  children: List.generate(100, (i) => ListTile(...)), // Will overflow!
)

// ✅ DO: Wrap in SingleChildScrollView for scrollable content
SingleChildScrollView(
  child: Column(
    children: List.generate(100, (i) => ListTile(...)),
  ),
)
```

**Mental Model:**

- Column = Vertical Stack (like a tower)
- Row = Horizontal Stack (like a shelf)
- Both use **MainAxis** (primary direction) and **CrossAxis** (perpendicular)

```
Column:                  Row:
MainAxis ↓              MainAxis →
┌─────────┐             ┌───┬───┬───┐
│  Child  │ ← CrossAxis │ C │ h │ i │
│  Child  │             │ h │ i │ l │
│  Child  │             │ i │ l │ d │
└─────────┘             │ l │ d │   │
                        │ d │   │   │
                        └───┴───┴───┘
                            ↑
                        CrossAxis
```

### Expanded vs Flexible: Space Distribution

```dart
// ✅ DO: Use Expanded when child should fill available space
Row(
  children: [
    Icon(Icons.star),
    Expanded(
      child: Text('This text takes remaining space'),
    ),
    Icon(Icons.more_vert),
  ],
)

// ✅ DO: Use Flexible when child can shrink smaller than its natural size
Row(
  children: [
    Flexible(
      child: Text('Long text that can wrap or overflow ellipsis'),
    ),
    Icon(Icons.arrow_forward),
  ],
)

// ✅ DO: Use flex ratio for proportional sizing
Row(
  children: [
    Expanded(flex: 2, child: Container(color: Colors.red)),
    Expanded(flex: 1, child: Container(color: Colors.blue)),
  ],
) // Red takes 2/3, Blue takes 1/3

// ❌ DON'T: Use multiple Expanded without considering total width
Row(
  children: [
    Expanded(child: VeryWideWidget()), // Will be forced to shrink
    Expanded(child: VeryWideWidget()), // Both compressed equally
  ],
)
```

**Decision Tree:**

```
Need to fill remaining space?
├─ YES, must take all space → Expanded
└─ NO, but can shrink if needed → Flexible

Need proportional sizing?
├─ YES → Expanded with flex values
└─ NO → Just use the widget directly
```

---

## 2. STACK vs COLUMN: Layering vs Stacking

### When to Use Stack

```dart
// ✅ DO: Use Stack for overlapping elements
Stack(
  children: [
    Image.network('background.jpg'),
    Positioned(
      top: 20,
      right: 20,
      child: Icon(Icons.favorite, color: Colors.red),
    ),
    Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black54,
        padding: EdgeInsets.all(16),
        child: Text('Caption', style: TextStyle(color: Colors.white)),
      ),
    ),
  ],
)

// ✅ DO: Use for floating action buttons over content
Stack(
  children: [
    ListView(...), // Main content
    Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(...),
    ),
  ],
)

// ❌ DON'T: Use Stack when Column would work
Stack( // Unnecessary complexity
  children: [
    Positioned(top: 0, child: Header()),
    Positioned(top: 100, child: Body()),
  ],
)
// ✅ DO: Use Column instead
Column(children: [Header(), Body()])
```

### Stack Positioning Patterns

```dart
// Pattern 1: Full-screen overlay
Stack(
  children: [
    MainContent(),
    Positioned.fill( // Covers entire stack
      child: LoadingOverlay(),
    ),
  ],
)

// Pattern 2: Badge on avatar
Stack(
  clipBehavior: Clip.none, // Allow overflow
  children: [
    CircleAvatar(radius: 40),
    Positioned(
      right: -5,
      top: -5,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text('5', style: TextStyle(color: Colors.white, fontSize: 12)),
      ),
    ),
  ],
)

// Pattern 3: App bar with back button over hero image
Stack(
  children: [
    Image.network('hero.jpg', height: 300, fit: BoxFit.cover),
    SafeArea(
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    ),
  ],
)
```

---

## 3. SCROLLING STRATEGIES: Production Patterns

### SingleChildScrollView vs ListView

```dart
// ✅ DO: Use SingleChildScrollView for small, known content
SingleChildScrollView(
  child: Column(
    children: [
      Header(),
      Form(child: ...),
      SubmitButton(),
    ],
  ),
)

// ✅ DO: Use ListView.builder for large/infinite lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(
    title: Text(items[index].name),
  ),
)

// ❌ DON'T: Put ListView inside Column without height constraint
Column(
  children: [
    Text('Header'),
    ListView(...), // ERROR: Unbounded height
  ],
)

// ✅ DO: Use Expanded to give ListView bounded height
Column(
  children: [
    Text('Header'),
    Expanded(
      child: ListView(...), // Now has constrained height
    ),
  ],
)
```

### Complex Scroll Patterns

```dart
// Pattern 1: Scrollable form with keyboard awareness
class FormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(decoration: InputDecoration(labelText: 'Name')),
              SizedBox(height: 16),
              TextField(decoration: InputDecoration(labelText: 'Email')),
              SizedBox(height: 16),
              TextField(decoration: InputDecoration(labelText: 'Password')),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {},
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pattern 2: Mixed scrollable sections
CustomScrollView(
  slivers: [
    SliverAppBar(
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(title: Text('Title')),
      pinned: true,
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text('Item $index')),
        childCount: 20,
      ),
    ),
    SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => GridTile(child: Image.network('...')),
        childCount: 10,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
    ),
  ],
)

// Pattern 3: Nested scrolling (use NestedScrollView)
NestedScrollView(
  headerSliverBuilder: (context, innerBoxIsScrolled) => [
    SliverAppBar(title: Text('Header'), pinned: true),
  ],
  body: TabBarView(
    children: [
      ListView(...), // Each tab can scroll independently
      ListView(...),
    ],
  ),
)
```

### Scroll Performance

```dart
// ❌ DON'T: Create expensive widgets in scroll
ListView.builder(
  itemBuilder: (context, index) {
    // Expensive computation on every scroll
    final processed = heavyProcessing(data[index]);
    return ExpensiveWidget(data: processed);
  },
)

// ✅ DO: Pre-process data or use cached widgets
class MyList extends StatelessWidget {
  final List<ProcessedData> items = data.map(heavyProcessing).toList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ListTile(title: Text(items[index].name)),
    );
  }
}

// ✅ DO: Use AutomaticKeepAliveClientMixin for stateful items
class ExpensiveListItem extends StatefulWidget {
  @override
  _ExpensiveListItemState createState() => _ExpensiveListItemState();
}

class _ExpensiveListItemState extends State<ExpensiveListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Must call super
    return ExpensiveWidget();
  }
}
```

---

## 4. KEYBOARD-SAFE UI PATTERNS

### The Resizing Problem

```dart
// ❌ DON'T: Ignore keyboard insets
Scaffold(
  body: Column(
    children: [
      Expanded(child: Content()),
      TextField(), // Gets hidden by keyboard
      ElevatedButton(onPressed: () {}, child: Text('Submit')),
    ],
  ),
)

// ✅ DO: Use resizeToAvoidBottomInset (default true)
Scaffold(
  resizeToAvoidBottomInset: true, // Default, but be explicit
  body: SingleChildScrollView(
    child: Column(
      children: [
        Content(),
        TextField(),
        SizedBox(height: 16),
        ElevatedButton(onPressed: () {}, child: Text('Submit')),
      ],
    ),
  ),
)

// ✅ DO: Use padding to account for keyboard
Scaffold(
  body: SafeArea(
    child: Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        children: [
          Expanded(child: Content()),
          TextField(),
          SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, child: Text('Submit')),
        ],
      ),
    ),
  ),
)
```

### Login Screen Pattern (Production-Ready)

```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 40),
                      // Logo
                      FlutterLogo(size: 80),
                      SizedBox(height: 40),
                      // Title
                      Text(
                        'Welcome Back',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sign in to continue',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),
                      // Email field
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),
                      // Password field
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(height: 8),
                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Forgot Password?'),
                        ),
                      ),
                      Spacer(), // Pushes button to bottom
                      // Login button
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text('Sign In'),
                      ),
                      SizedBox(height: 16),
                      // Sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {},
                            child: Text('Sign Up'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

---

## 5. CENTERING TECHNIQUES

### True Center vs Relative Center

```dart
// Pattern 1: True vertical center
Center(
  child: Text('Perfectly centered'),
)

// Pattern 2: Center with offset (visual balance)
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    SizedBox(height: 100), // Push content down slightly
    Text('Visually centered'),
    Spacer(),
  ],
)

// Pattern 3: Center horizontally, align vertically
Column(
  crossAxisAlignment: CrossAxisAlignment.center, // Horizontal center
  children: [
    Text('Title'),
    Text('Subtitle'),
  ],
)

// Pattern 4: Center in available space (not screen)
Expanded(
  child: Center(
    child: Text('Centered in remaining space'),
  ),
)
```

### Complex Centering Patterns

```dart
// Empty state screen
class EmptyStateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Don't stretch
            children: [
              Icon(Icons.inbox, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No Items Found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8),
              Text(
                'Add your first item to get started',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Loading overlay (center over existing content)
Stack(
  children: [
    MainContent(),
    if (isLoading)
      Container(
        color: Colors.black45,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
  ],
)
```

---

## 6. RESPONSIVE DESIGN: MediaQuery vs LayoutBuilder

### When to Use What

```dart
// ✅ DO: Use MediaQuery for screen-level decisions
final screenWidth = MediaQuery.of(context).size.width;
final isTablet = screenWidth > 600;

// ✅ DO: Use LayoutBuilder for widget-level decisions
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return WideLayout();
    }
    return NarrowLayout();
  },
)

// ❌ DON'T: Use MediaQuery inside deeply nested widgets
// (Use LayoutBuilder for local constraints)
```

### Responsive Grid Pattern

```dart
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine columns based on width
        int columns;
        if (constraints.maxWidth > 1200) {
          columns = 4;
        } else if (constraints.maxWidth > 800) {
          columns = 3;
        } else if (constraints.maxWidth > 600) {
          columns = 2;
        } else {
          columns = 1;
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}
```

### Adaptive Layouts (Phone vs Tablet)

```dart
class AdaptiveScaffold extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;

  const AdaptiveScaffold({
    required this.mobileBody,
    required this.tabletBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          // Tablet: Master-detail layout
          return Row(
            children: [
              SizedBox(
                width: 300,
                child: mobileBody, // List on left
              ),
              VerticalDivider(width: 1),
              Expanded(
                child: tabletBody, // Detail on right
              ),
            ],
          );
        } else {
          // Phone: Single pane
          return mobileBody;
        }
      },
    );
  }
}
```

### Responsive Text and Spacing

```dart
class ResponsiveText extends StatelessWidget {
  final String text;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Scale font size
    double fontSize;
    if (screenWidth > 600) {
      fontSize = 24;
    } else {
      fontSize = 18;
    }

    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }
}

// Better: Use Theme and scale factor
class BetterResponsiveText extends StatelessWidget {
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium,
      textScaleFactor: MediaQuery.of(context).size.width > 600 ? 1.2 : 1.0,
    );
  }
}
```

---

## 7. COMMON MISTAKES & ANTI-PATTERNS

### Mistake 1: Unbounded Constraints

```dart
// ❌ DON'T: Nest flexible widgets without constraints
Row(
  children: [
    Expanded(
      child: ListView(...), // ERROR: Horizontal constraint, but vertical unbounded
    ),
  ],
)

// ✅ DO: Provide both constraints
SizedBox(
  height: 200,
  child: Row(
    children: [
      Expanded(child: ListView(...)),
    ],
  ),
)
```

### Mistake 2: Unnecessary Nesting

```dart
// ❌ DON'T: Over-nest
Container(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Text('Hello'),
          ),
        ],
      ),
    ),
  ),
)

// ✅ DO: Flatten when possible
Padding(
  padding: EdgeInsets.all(16),
  child: Center(
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Text('Hello'),
    ),
  ),
)

// ✅ BETTER: Combine padding
Center(
  child: Padding(
    padding: EdgeInsets.all(24), // 16 + 8
    child: Text('Hello'),
  ),
)
```

### Mistake 3: Ignoring SafeArea

```dart
// ❌ DON'T: Ignore notches and system UI
Scaffold(
  body: Column(
    children: [
      AppBar(...), // Gets cut off by notch
      Content(),
    ],
  ),
)

// ✅ DO: Use SafeArea
Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        AppBar(...),
        Content(),
      ],
    ),
  ),
)

// ✅ OR: Use Scaffold's built-in appBar
Scaffold(
  appBar: AppBar(...), // Automatically safe
  body: Content(),
)
```

### Mistake 4: Hardcoded Dimensions

```dart
// ❌ DON'T: Hardcode screen percentages
Container(
  width: 375, // iPhone size - breaks on other devices
  height: 200,
)

// ✅ DO: Use relative sizing
Container(
  width: MediaQuery.of(context).size.width * 0.9,
  height: 200,
)

// ✅ BETTER: Use constraints
ConstrainedBox(
  constraints: BoxConstraints(
    maxWidth: 600, // Max size
    minWidth: 300, // Min size
  ),
  child: Container(
    width: double.infinity,
  ),
)
```

---

## 8. REAL-WORLD UI PATTERNS

### Pattern 1: Dashboard Screen

```dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header stats
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Revenue',
                      value: '\$12,345',
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      title: 'Users',
                      value: '1,234',
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Chart section
              Text(
                'Analytics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('[Chart Here]')),
              ),
              SizedBox(height: 24),

              // Recent activity
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),
              ...List.generate(
                5,
                (index) => Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text('Activity Item ${index + 1}'),
                    subtitle: Text('2 hours ago'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Pattern 2: Profile Screen with Header

```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsing header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('John Doe'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://via.placeholder.com/400x200',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('Posts', '123'),
                      _buildStat('Followers', '1.2K'),
                      _buildStat('Following', '456'),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Bio
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Mobile app developer. Flutter enthusiast. Coffee lover.',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Follow'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text('Message'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Post grid
          SliverPadding(
            padding: EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  color: Colors.grey.shade300,
                  child: Center(child: Text('Post ${index + 1}')),
                ),
                childCount: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
```

### Pattern 3: Form with Validation

```dart
class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Process form
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 9. QUICK REFERENCE DECISION TREE

```
Need to arrange widgets?
├─ Vertically? → Column
├─ Horizontally? → Row
└─ Overlapping? → Stack

Need scrolling?
├─ Small content? → SingleChildScrollView + Column
├─ Large list? → ListView.builder
├─ Grid? → GridView
└─ Mixed content? → CustomScrollView

Need to fill space?
├─ Fill all remaining? → Expanded
├─ Can shrink if needed? → Flexible
└─ Fixed size? → SizedBox

Need centering?
├─ True center? → Center
├─ Center in axis? → mainAxisAlignment/crossAxisAlignment
└─ Center with offset? → Column + Spacer

Need responsiveness?
├─ Screen-level? → MediaQuery
├─ Widget-level? → LayoutBuilder
└─ Adaptive layout? → LayoutBuilder + breakpoints

Keyboard showing?
├─ Form screen? → SingleChildScrollView + resizeToAvoidBottomInset
├─ Fixed bottom? → Padding with viewInsets.bottom
└─ Chat screen? → ListView + reverse
```

---

## 10. PERFORMANCE CHECKLIST

✅ **DO:**

- Use `const` constructors wherever possible
- Use `ListView.builder` for long lists
- Implement `AutomaticKeepAliveClientMixin` for expensive list items
- Use `RepaintBoundary` for complex animations
- Profile with DevTools before optimizing

❌ **DON'T:**

- Build expensive widgets in `itemBuilder` callbacks
- Use `setState` in large widget trees (use state management)
- Nest multiple `StreamBuilder`/`FutureBuilder` widgets
- Rebuild entire screens for small changes
- Ignore memory leaks (dispose controllers!)

---

This cheat sheet covers 90% of real-world layout scenarios. Bookmark it and refer back when building production apps! 🚀

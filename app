// ================= SPEND TRACKER + LIVE API (22 blanks) =================
// Replace every ____N____ with the correct code. Follow the instructor!
// This app needs internet: it fetches live INR -> USD, EUR, AED, AUD rates from an API.

// BLANK 1: Dart's built-in library that turns JSON text into data
import 'dart:convert';
import 'package:flutter/material.dart';
// BLANK 2: the package name that lets us talk to the internet
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// ---------- Our colours and style helpers (already done for you) ----------
const Color ink = Color(0xFF22223B); // deep navy for text and borders
const Color paper = Color(0xFFFDF6EC); // warm cream background
const Color accent = Color(0xFFFFD6A5); // apricot total card
const Color pop = Color(0xFFFF7A90); // coral for shadows

// A flat box with a thick border and a hard offset shadow
BoxDecoration brutalBox(Color fill, {Color shadow = ink}) {
  return BoxDecoration(
    color: fill,
    border: Border.all(color: ink, width: 2.5),
    boxShadow: [BoxShadow(color: shadow, offset: const Offset(5, 5))],
  );
}

InputDecoration inputStyle(String label) {
  const side = BorderSide(color: ink, width: 2);
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
      fontWeight: FontWeight.w700,
      letterSpacing: 1,
      color: ink,
    ),
    filled: true,
    fillColor: Colors.white,
    border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero, borderSide: side),
    enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero, borderSide: side),
    focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: ink, width: 3.5)),
  );
}

// ---------- STAGE 1: App shell + data model ----------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: paper,
        colorScheme: const ColorScheme.light(primary: ink),
      ),
      home: const ExpensePage(),
    );
  }
}

class Expense {
  final String name;
  // BLANK 3: money can have decimals, so which number type?
  final double amount;
  final String category;
  Expense(this.name, this.amount, this.category);
}

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  // The app's "state": data that changes while the app runs
  // BLANK 4: a list that holds Expense objects -> List<____>
  final List<Expense> expenses = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Each category has its own colour
  final Map<String, Color> categories = {
    'Food': const Color(0xFFFFADAD),
    'Travel': const Color(0xFF9BF6FF),
    'Books': const Color(0xFFCAFFBF),
    'Fun': const Color(0xFFBDB2FF),
  };
  String selectedCategory = 'Food';

  // State for the API result
  final List<String> currencies = ['USD', 'EUR', 'AED', 'AUD'];
  String selectedCurrency = 'USD';
  Map<String, double> rates = {};
  bool loadingRate = false;
  String rateError = '';

  // ---------- STAGE 2: Talking to the internet (API) ----------
  @override
  void initState() {
    super.initState();
    // BLANK 5: call the function (defined below) that fetches the rate
    // as soon as the screen opens
    fetchRate();
  }

  // BLANK 6: waiting for the internet takes time, so this function
  // must be marked with the keyword ______
  Future<void> fetchRate() async {
    setState(() {
      loadingRate = true;
      rateError = '';
    });
    try {
      // BLANK 7: turn the text address into a proper Uri -> Uri.____(...)
      final url = Uri.parse(
          'https://open.er-api.com/v6/latest/INR');

      // BLANK 8: pause here until the server replies
      final response = await http.get(url);

      // BLANK 9: the HTTP status code that means "OK"
      if (response.statusCode == 200) {
        // BLANK 10: turn the JSON text into a Map we can read
        final data = jsonDecode(response.body);

        // The reply looks like:
        // {"base_code":"INR","rates":{"USD":0.011,"EUR":0.010,"AED":0.041,...}}
        // BLANK 11: which key holds all the currency rates?
        final all = data['rates'];

        setState(() {
          for (var code in currencies) {
            rates[code] = (all[code] as num).toDouble();
          }
        });
      } else {
        setState(() {
          rateError = 'Server error';
        });
      }
    } catch (e) {
      setState(() {
        rateError = 'No internet';
      });
    }
    setState(() {
      loadingRate = false;
    });
  }

  // ---------- STAGE 3: Logic ----------
  double getTotal() {
    double sum = 0;
    for (var e in expenses) {
      // BLANK 12: which field of the expense do we add up?
      sum += e.amount;
    }
    return sum;
  }

  void addExpense() {
    final name = nameController.text;
    final amount = double.tryParse(amountController.text);
    if (name.isEmpty || amount == null) return;

    // BLANK 13: tells Flutter "data changed, redraw the screen!"
    setState(() {
      // BLANK 14: write the full line that adds a new Expense
      // (made from name, amount and selectedCategory) to the expenses list
      expenses.add(Expense(name,amount,selectedCategory));
    });

    nameController.clear();
    amountController.clear();
  }

  void deleteExpense(int index) {
    // BLANK 15: how does delete work? Write the code that removes the item
    // at this index AND makes the screen redraw (hint: same trick as addExpense)
    setState((){expenses.removeAt(index);});
  }

  // ---------- STAGE 4: UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: paper,
        surfaceTintColor: Colors.transparent,
        shape: const Border(bottom: BorderSide(color: ink, width: 2.5)),
        // BLANK 16: give your app a name!
        title: const Text(
          'M expense tracker',
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          // BLANK 17: position of the widgets. We want every child to stretch
          // across the full width -> CrossAxisAlignment.____
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The total card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: brutalBox(accent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL SPENT',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${getTotal().toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        // BLANK 18: show "Fetching rate..." while this state
                        // variable is true, otherwise show the USD amount
                        child: loadingRate
                            ? const Text('Fetching rate...',
                                style: TextStyle(fontWeight: FontWeight.w700))
                            : Text(
                                rateError.isNotEmpty
                                    ? rateError
                                    : '≈ ${(getTotal() * (rates[selectedCurrency] ?? 0)).toStringAsFixed(2)} $selectedCurrency',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                      ),
                      GestureDetector(
                        onTap: fetchRate,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: ink, width: 2),
                          ),
                          child: const Icon(Icons.refresh, color: ink),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Currency tags
            const Text(
              'SHOW TOTAL IN',
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: currencies.map((code) {
                final selected = selectedCurrency == code;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCurrency = code;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? ink : Colors.white,
                      border: Border.all(color: ink, width: 2),
                    ),
                    child: Text(
                      code,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: selected ? Colors.white : ink,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            const Text(
              'Rates by exchangerate-api.com',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Category tags
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.keys.map((c) {
                final selected = selectedCategory == c;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = c;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? categories[c] : Colors.white,
                      border: Border.all(color: ink, width: 2),
                    ),
                    child: Text(
                      c.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, letterSpacing: 1),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            TextField(
              // BLANK 19: connect this box to the controller that reads the name
              controller: nameController,
              decoration: inputStyle('WHAT DID YOU BUY?'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: inputStyle('AMOUNT (₹)'),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              // BLANK 20: which function runs when the button is tapped?
              onTap: addExpense,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: brutalBox(ink, shadow: pop),
                child: const Center(
                  child: Text(
                    'ADD EXPENSE  →',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ---------- STAGE 5: The list ----------
            expenses.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'NOTHING SPENT YET.',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: Colors.black45),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                      // BLANK 21: how many items should the list show?
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final e = expenses[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: ink, width: 2),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                    width: 10, color: categories[e.category]),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.name,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Text(
                                          e.category.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 11,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '₹${e.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                GestureDetector(
                                  // BLANK 22: when tapped, call deleteExpense for THIS item
                                  // (hint: a function with no name that calls deleteExpense with index)
                                  onTap: () => deleteExpense(index),
                                  child: const Padding(
                                    padding: EdgeInsets.all(14),
                                    child: Center(
                                      child: Icon(Icons.close, color: ink),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ],
        ),
      ),
    );
  }
}

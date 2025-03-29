class ExpenseCalculator {
  double calcTotalSpent(List<Map<String, dynamic>> transactions) {
    return transactions.fold(0, (sum, txn) => sum + txn['amount']);
  }

  Map<String, dynamic> calculateSettlements(List<dynamic> expenses) {
    // Map to track total paid and total owed by each person
    Map<String, double> totalPaid = {};
    Map<String, double> totalOwed = {};

    // Iterate through each expense entry
    for (var expense in expenses) {
      String paidByName = expense['paidBy']['name'];
      double totalAmount = expense['amount'].toDouble();

      // Track total amount paid by this person
      totalPaid[paidByName] = (totalPaid[paidByName] ?? 0) + totalAmount;

      // Calculate how much each person owes
      for (var distribution in expense['distributedTo']) {
        String userName = distribution['userId']['name'];
        double distributedAmount = distribution['amount'].toDouble();

        // Track total amount owed by this person
        totalOwed[userName] = (totalOwed[userName] ?? 0) + distributedAmount;
      }
    }

    // Calculate net balances
    Map<String, double> netBalances = {};
    Set<String> allUsers = {...totalPaid.keys, ...totalOwed.keys};

    for (var user in allUsers) {
      double paid = totalPaid[user] ?? 0;
      double owed = totalOwed[user] ?? 0;
      netBalances[user] = paid - owed;
    }

    // Generate settlements
    List<Map<String, dynamic>> settlements = [];
    List<String> sortedUsers = netBalances.keys.toList();
    sortedUsers.sort((a, b) => netBalances[b]!.compareTo(netBalances[a]!));

    for (int i = 0; i < sortedUsers.length; i++) {
      for (int j = i + 1; j < sortedUsers.length; j++) {
        String creditor = sortedUsers[i];
        String debtor = sortedUsers[j];

        if (netBalances[creditor]! > 0 && netBalances[debtor]! < 0) {
          double settleAmount = min(
            netBalances[creditor]!,
            -netBalances[debtor]!,
          );

          if (settleAmount > 0) {
            settlements.add({
              'from': debtor,
              'to': creditor,
              'amount': settleAmount.round(),
            });

            // Update net balances
            netBalances[creditor] = (netBalances[creditor]! - settleAmount);
            netBalances[debtor] = (netBalances[debtor]! + settleAmount);
          }
        }
      }
    }

    return {
      'totalPaid': totalPaid,
      'totalOwed': totalOwed,
      'netBalances': netBalances,
      'settlements': settlements,
    };
  }

  double min(double a, double b) {
    return a < b ? a : b;
  }
}

void main() {
  ExpenseCalculator calculator = ExpenseCalculator();

  List<Map<String, dynamic>> expenses = [
    {
      "_id": "67e671a5cfaf5ad721120296",
      "tripId": "67dfdefddf5f89e5bee84bfc",
      "paidBy": {"_id": "67dfdefcdf5f89e5bee84bfa", "name": "mannPadhiyar"},
      "amount": 400,
      "description": "tea",
      "distributedTo": [
        {
          "userId": {"_id": "67dd65cc4853693d8120cc1e", "name": "meet"},
          "amount": 100,
          "_id": "67e671a5cfaf5ad721120297",
        },
        {
          "userId": {"_id": "67dd6c6f35ddea5245fdc9fd", "name": "dhruv"},
          "amount": 100,
          "_id": "67e671a5cfaf5ad721120298",
        },
        {
          "userId": {"_id": "67dfdef6df5f89e5bee84bf7", "name": "het"},
          "amount": 100,
          "_id": "67e671a5cfaf5ad721120299",
        },
        {
          "userId": {"_id": "67dfdefcdf5f89e5bee84bfa", "name": "mannPadhiyar"},
          "amount": 100,
          "_id": "67e671a5cfaf5ad72112029a",
        },
      ],
      "__v": 0,
    },
    {
      "_id": "67e67420cfaf5ad7211202aa",
      "tripId": "67dfdefddf5f89e5bee84bfc",
      "paidBy": {"_id": "67dd6c6f35ddea5245fdc9fd", "name": "dhruv"},
      "amount": 4000,
      "description": "tire",
      "distributedTo": [
        {
          "userId": {"_id": "67dd65cc4853693d8120cc1e", "name": "meet"},
          "amount": 1000,
          "_id": "67e67420cfaf5ad7211202ab",
        },
        {
          "userId": {"_id": "67dd6c6f35ddea5245fdc9fd", "name": "dhruv"},
          "amount": 1000,
          "_id": "67e67420cfaf5ad7211202ac",
        },
        {
          "userId": {"_id": "67dfdef6df5f89e5bee84bf7", "name": "het"},
          "amount": 1000,
          "_id": "67e67420cfaf5ad7211202ad",
        },
        {
          "userId": {"_id": "67dfdefcdf5f89e5bee84bfa", "name": "mannPadhiyar"},
          "amount": 1000,
          "_id": "67e67420cfaf5ad7211202ae",
        },
      ],
      "__v": 0,
    },
  ];
  Map<String, dynamic> result = calculator.calculateSettlements(expenses);
  print(result);
  // print('Total Paid: ${result['totalPaid']}');
  // print('Total Owed: ${result['totalOwed']}');
  // print('Net Balances: ${result['netBalances']}');
  // print('Settlements: ${result['settlements']}');
}

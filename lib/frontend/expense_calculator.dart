class ExpenseCalculator{
  double calcTotalSpent(List<Map<String, dynamic>> transactions){
    return transactions.fold(0, (sum, txn) => sum + txn['amount']);
  }
}

void main(){
  List<Map<String,dynamic>> li = [
    {
      "_id": "67e3c784bd994ef0771984ad",
      "tripId": "67dfdefddf5f89e5bee84bfc",
      "paidBy": {
        "_id": "67dfdefcdf5f89e5bee84bfa",
        "name": "mannPadhiyar"
      },
      "amount": 120,
      "description": "food of zorko",
      "distributedTo": [
        {
          "_id": "67dfdef6df5f89e5bee84bf7"
        },
        {
          "_id": "67dfdefcdf5f89e5bee84bfa"
        }
      ],
      "__v": 0
    },
    {
      "_id": "67e3de551815bd81dbcf321b",
      "tripId": "67dfdefddf5f89e5bee84bfc",
      "paidBy": {
        "_id": "67dd6c6f35ddea5245fdc9fd",
        "name": "dhruv"
      },
      "amount": 500,
      "description": "drink",
      "distributedTo": [
        {
          "_id": "67dd65cc4853693d8120cc1e"
        },
        {
          "_id": "67dd6c6f35ddea5245fdc9fd"
        },
        {
          "_id": "67dfdef6df5f89e5bee84bf7"
        },
        {
          "_id": "67dfdefcdf5f89e5bee84bfa"
        }
      ],
      "__v": 0
    },
    {
      "_id": "67e3df7e1815bd81dbcf3245",
      "tripId": "67dfdefddf5f89e5bee84bfc",
      "paidBy": {
        "_id": "67dd65cc4853693d8120cc1e",
        "name": "meet"
      },
      "amount": 50,
      "description": "yoyo",
      "distributedTo": [
        {
          "_id": "67dd65cc4853693d8120cc1e"
        },
        {
          "_id": "67dd6c6f35ddea5245fdc9fd"
        },
        {
          "_id": "67dfdef6df5f89e5bee84bf7"
        },
        {
          "_id": "67dfdefcdf5f89e5bee84bfa"
        }
      ],
      "__v": 0
    },
    {
      "_id": "67e3e03d1815bd81dbcf3266",
      "tripId": "67dfdefddf5f89e5bee84bfc",
      "paidBy": {
        "_id": "67dfdefcdf5f89e5bee84bfa",
        "name": "mannPadhiyar"
      },
      "amount": 50,
      "description": "hello",
      "distributedTo": [
        {
          "_id": "67dd65cc4853693d8120cc1e"
        },
        {
          "_id": "67dd6c6f35ddea5245fdc9fd"
        },
        {
          "_id": "67dfdef6df5f89e5bee84bf7"
        },
        {
          "_id": "67dfdefcdf5f89e5bee84bfa"
        }
      ],
      "__v": 0
    },
    {
      "_id": "67e3e0731815bd81dbcf327c",
      "tripId": "67dfdefddf5f89e5bee84bfc",
      "paidBy": {
        "_id": "67dfdefcdf5f89e5bee84bfa",
        "name": "mannPadhiyar"
      },
      "amount": 111,
      "description": "chandlo",
      "distributedTo": [
        {
          "_id": "67dd65cc4853693d8120cc1e"
        },
        {
          "_id": "67dd6c6f35ddea5245fdc9fd"
        },
        {
          "_id": "67dfdef6df5f89e5bee84bf7"
        },
        {
          "_id": "67dfdefcdf5f89e5bee84bfa"
        }
      ],
      "__v": 0
    }
  ];

  ExpenseCalculator calculator = ExpenseCalculator();
  print(calculator.calcTotalSpent(li));
}
# 01_Time_Converter.py

def minutes_to_hours(minutes: int) -> str:
    hrs = minutes // 60
    mins = minutes % 60
    return f"{hrs} hrs {mins} minutes"


if __name__ == "__main__":
    user_input = int(input("Enter total minutes: "))
    result = minutes_to_hours(user_input)
    print(result)

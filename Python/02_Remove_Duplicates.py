def remove_duplicates(text: str) -> str:
    result = ""
    for ch in text:
        if ch not in result:
            result += ch
    return result


if __name__ == "__main__":
    user_input = input("Enter a string: ")
    result = remove_duplicates(user_input)
    print(result)

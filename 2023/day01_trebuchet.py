# Part 1 was easy for ChatGPT


def find_first_and_last_digit(s):
    # Find the index of the first digit in the string
    first_digit_index = next((i for i, c in enumerate(s) if c.isdigit()), None)

    # Find the index of the last digit in the string
    last_digit_index = next((i for i, c in enumerate(s[::-1]) if c.isdigit()), None)

    # Extract the first and last digits
    first_digit = int(s[first_digit_index]) if first_digit_index is not None else None
    last_digit = (
        int(s[len(s) - last_digit_index - 1]) if last_digit_index is not None else None
    )

    if first_digit is not None and last_digit is not None:
        two_digit_number = 10 * first_digit + last_digit
        return two_digit_number
    else:
        raise Exception("No two-digit number found in the string")


def sum_two_digit_numbers_from_file(file_path):
    total_sum = 0

    try:
        with open(file_path, "r") as file:
            # Read each line from the file
            for line in file:
                # Extract two-digit numbers from the line
                two_digit_numbers = [find_first_and_last_digit(line)]

                # Sum the two-digit numbers
                total_sum += sum(two_digit_numbers)

    except FileNotFoundError:
        print(f"File '{file_path}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

    return total_sum


file_path = "input/day01.txt"
result = sum_two_digit_numbers_from_file(file_path)

print(f"[PART 1] Sum of two-digit numbers from file: {result}")

# Part 2 needed a lot of coaxing


def find_info_of_first_digit_word(s):
    digit_words = [
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine",
    ]
    word_to_digit_mapping = {
        "one": "1",
        "two": "2",
        "three": "3",
        "four": "4",
        "five": "5",
        "six": "6",
        "seven": "7",
        "eight": "8",
        "nine": "9",
    }

    first_index = -1
    digit_word = None

    for i in range(len(s)):
        for word in digit_words:
            if s[i : i + len(word)].lower() == word:
                first_index = i
                digit_word = word
                return word_to_digit_mapping.get(digit_word, None), first_index

    return None, -1


def find_info_of_last_digit_word(s):
    digit_words = [
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine",
    ]
    word_to_digit_mapping = {
        "one": "1",
        "two": "2",
        "three": "3",
        "four": "4",
        "five": "5",
        "six": "6",
        "seven": "7",
        "eight": "8",
        "nine": "9",
    }

    last_index = -1
    digit_word = None

    for i in range(len(s)):
        for word in digit_words:
            if s[i : i + len(word)].lower() == word:
                last_index = i + len(word) - 1
                digit_word = word

    return word_to_digit_mapping.get(digit_word, None), last_index


def find_info_of_first_direct_digit(s):
    first_index = -1
    digit_value = None

    for i, c in enumerate(s):
        if c.isdigit():
            first_index = i
            digit_value = int(c)
            break

    return digit_value, first_index


def find_info_of_last_direct_digit(s):
    last_index = -1
    digit_value = None

    for i, c in enumerate(s):
        if c.isdigit():
            last_index = i
            digit_value = int(c)

    return digit_value, last_index


def find_info_of_first_digit(s):
    # Find the first direct digit
    (
        first_direct_digit_value,
        first_direct_digit_index,
    ) = find_info_of_first_direct_digit(s)

    # Find the first digit word
    first_digit_word_value, first_digit_word_index = find_info_of_first_digit_word(s)

    # Compare the indexes and use the first non-negative index
    if first_direct_digit_index != -1 and (
        first_digit_word_index == -1
        or first_direct_digit_index < first_digit_word_index
    ):
        return first_direct_digit_value, first_direct_digit_index
    elif first_digit_word_index != -1:
        return int(first_digit_word_value), first_digit_word_index
    else:
        return None, -1


def find_info_of_last_digit(s):
    # Find the last direct digit
    last_direct_digit_value, last_direct_digit_index = find_info_of_last_direct_digit(s)

    # Find the last digit word
    last_digit_word_value, last_digit_word_index = find_info_of_last_digit_word(s)

    # Compare the indexes and use the last non-negative index
    if last_direct_digit_index != -1 and (
        last_digit_word_index == -1 or last_direct_digit_index > last_digit_word_index
    ):
        return last_direct_digit_value, last_direct_digit_index
    elif last_digit_word_index != -1:
        return int(last_digit_word_value), last_digit_word_index
    else:
        return None, -1


def find_first_and_last_digit_part2(s):
    first_digit, _ = find_info_of_first_digit(s)
    print("first", first_digit)
    last_digit, _ = find_info_of_last_digit(s)
    print("last", last_digit)
    if first_digit is not None and last_digit is not None:
        two_digit_number = 10 * first_digit + last_digit
        return two_digit_number
    else:
        raise Exception("No two-digit number found in the string")


def sum_two_digit_numbers_from_file_part2(file_path):
    total_sum = 0

    try:
        with open(file_path, "r") as file:
            # Read each line from the file
            for line in file:
                print(line)
                # Extract two-digit numbers from the line
                two_digit_numbers = [find_first_and_last_digit_part2(line)]
                print(line, two_digit_numbers)

                # Sum the two-digit numbers
                total_sum += sum(two_digit_numbers)

    except FileNotFoundError:
        print(f"File '{file_path}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

    return total_sum


file_path = "input/day01.txt"
result = sum_two_digit_numbers_from_file_part2(file_path)

print(f"[PART 2] Sum of two-digit numbers from file: {result}")

import os
import argparse
import subprocess
import datetime
from dataclasses import dataclass

### Color Utils ###


def red(s: str) -> str:
    return f"\033[31m{s}\033[0m"


def green(s: str) -> str:
    return f"\033[32m{s}\033[0m"

def box(s: str) -> str:
    return f"\033[1;7;37m{s}\033[0m"

### Test Utils ###


@dataclass
class Test:
    filename: str
    inputs: list[str] | None
    expected: list[str] | None
    should_fail: bool

    def parse_file(filename: str) -> "Test":
        content = open(filename).readlines()
        comment = []
        for line in content:
            # get comment, start with //
            if line.startswith("//"):
                comment.append(line[2:])
            else:
                break
        if len(comment) == 0:  # no comment
            return Test(filename, None, None, False)
        elif len(comment) == 1:  # one line comment must be error
            if "Error" in comment[0]:
                return Test(filename, None, None, True)
            else:
                return Test(filename, None, None, False)
        else:  # input and output
            assert len(
                comment) % 2 == 0, f"Error: {filename} has non-paired input/output"
            inputs = []
            expected = []
            for i in range(0, len(comment), 2):
                assert "Expected Input:" in comment[i], f"Error: {filename} has non-paired input/output"
                assert "Expected Output:" in comment[i +
                                                     1], f"Error: {filename} has non-paired input/output"
                inputs.append(comment[i].replace(
                    "Expected Input:", "").strip())
                expected.append(
                    comment[i + 1].replace("Expected Output:", "").strip())
            return Test(filename, inputs, expected, False)

    def __str__(self):
        return f"Test({self.filename}, {self.inputs}, {self.expected}, {self.should_fail})"


class TestResult:
    def __init__(self, test: Test, output: str | None, exit_code: int):
        self.test = test
        self.output = output
        self.exit_code = exit_code
        if test.should_fail:
            self.passed = exit_code != 0
        else:
            if test.expected is None:
                self.passed = exit_code == 0
            else:
                self.passed = exit_code == 0 and output == test.expected


def run_on_test(compiler: str, test: Test) -> TestResult:
    """
    Run the given file on the given test testfile
    """
    if test.inputs is None:  # no input
        try:
            result = subprocess.run(
                [compiler, test.filename], capture_output=True, timeout=5)
        except subprocess.TimeoutExpired:
            print(f"Error: {test.filename} timed out.")
            return TestResult(test, None, -1)
        # get exit code and output
        exit_code = result.returncode
        output = result.stdout.decode("utf-8")
        return TestResult(test, output, exit_code)
    assert False, "Not implemented"


def summary(test_results: list[TestResult]):
    # get the longest filename
    max_filename = max([len(test_result.test.filename)
                        for test_result in test_results])
    for test_result in test_results:
        # align the filename
        print(f"{test_result.test.filename.ljust(max_filename)}  ", end="")
        print(f"{green('PASSED') if test_result.passed else red('FAILED')}")
    passed = len([test for test in test_results if test.passed])
    print()
    if passed == len(test_results):
        print(green("All tests passed!"))
    else:
        print(f"{passed}/{len(test_results)} tests passed.")


def lab_test(compiler: str, lab: str) -> list[TestResult]:
    print(box(f"Running {lab} test..."))
    tests = os.listdir(f"tests/{lab}")
    tests = [Test.parse_file(f"tests/{lab}/{test}") for test in tests]
    test_results = [run_on_test(compiler, test) for test in tests]
    return test_results


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Test your compiler.")
    parser.add_argument("input_file", type=str, help="your complier file")
    parser.add_argument("lab", type=str, help="which lab to test",
                        choices=["lab1", "lab2", "lab3", "lab4"])

    args = parser.parse_args()
    input_file = args.input_file
    if not os.path.exists(input_file):
        print(f"File {input_file} not found.")
        exit(1)
    test_results = lab_test(input_file, args.lab)
    summary(test_results)
    print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))

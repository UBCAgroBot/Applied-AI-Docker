import subprocess
import os

def check_cmake():
    try:
        # Check CMake version
        cmake_version = subprocess.check_output(["cmake", "--version"]).decode("utf-8")
        print("CMake version:", cmake_version.splitlines()[0])

        # Create a simple CMake project to test
        os.makedirs("cmake_test_project", exist_ok=True)
        with open("cmake_test_project/CMakeLists.txt", "w") as f:
            f.write("""
            cmake_minimum_required(VERSION 3.0)
            project(TestProject)
            add_executable(test_program main.cpp)
            """)
        
        with open("cmake_test_project/main.cpp", "w") as f:
            f.write("""
            #include <iostream>
            int main() {
                std::cout << "CMake Test Program Running Successfully!" << std::endl;
                return 0;
            }
            """)

        # Run CMake commands
        subprocess.check_call(["cmake", "."], cwd="cmake_test_project")
        subprocess.check_call(["cmake", "--build", "."], cwd="cmake_test_project")

        # Run the compiled program
        result = subprocess.check_output(["./cmake_test_project/test_program"]).decode("utf-8")
        print("CMake test program output:", result.strip())

    except subprocess.CalledProcessError as e:
        print("CMake test failed:", e)
    except FileNotFoundError:
        print("CMake is not installed or not in the system PATH.")

check_cmake()
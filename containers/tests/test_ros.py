import subprocess
import os

def check_ros2():
    try:
        # Source ROS 2 setup script
        ros2_setup_script = "/opt/ros/foxy/setup.bash"  # Update if necessary
        if not os.path.exists(ros2_setup_script):
            print("ROS 2 setup script not found. Please verify the installation path.")
            return

        # Check ROS 2 installation
        print("Sourcing ROS 2 environment...")
        subprocess.check_call(f"source {ros2_setup_script} && ros2 --version", shell=True, executable="/bin/bash")

        # Run a basic ROS 2 command to list nodes
        print("Testing ROS 2 functionality...")
        topics = subprocess.check_output(f"source {ros2_setup_script} && ros2 topic list", shell=True, executable="/bin/bash").decode("utf-8")

        if topics:
            print("ROS 2 is functioning correctly. Topics available:", topics)
        else:
            print("ROS 2 is installed, but no topics are available.")

    except subprocess.CalledProcessError as e:
        print("ROS 2 test failed:", e)
    except FileNotFoundError:
        print("ROS 2 is not installed or not in the system PATH.")

check_ros2()
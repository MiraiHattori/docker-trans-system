# setup
execute commands below
```bash
./clone_catkin_ws.sh # to revert, call rm -rf catkin_ws
./clone_choreonoid.sh # to revert, call rm -rf choreonoid_ws
./docker_build.sh # to revert, call docker rm choreonoidsim
./choreonoid_build.sh # to revert, call ./choreonoid_clean.sh
./catkin_build.sh # to revert, call ./catkin_clean.sh
```

## my setup
```bash
./my_clone_tennis.sh
./my_tennis_build.sh
```

# execute
```bash
./my_launch_tennis.sh
```
```bash
# another terminal
./docker_exec.sh
root@docker # ./scripts-on-docker/my_motion_exec.sh
# press enter when you want to start stabilizer
```
```bash
# another terminal
./docker_exec.sh
root@docker # ./scripts-on-docker/my_vision_launch.sh
```
```bash
# another terminal
./docker_exec.sh
root@docker # ./scripts-on-docker/my_throw_ball.sh
```

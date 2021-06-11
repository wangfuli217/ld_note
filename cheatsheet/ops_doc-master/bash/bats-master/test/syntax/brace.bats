

# Write a warning in big fat letters about [[ somewhere in the readme 
@test "t1" {
    run sh -c false
    [ $status = 1 ]
}

@test "t2" {
    run sh -c false
    [[ $status == 1 ]]
}

@test "t3" {
    run sh -c true
    [ $status = 0 ]
}

@test "t4" {
    run sh -c true
    [[ $status == 0 ]]
}

# Stuck on the last test of each file
@test "fork something" {
    sleep 5 &
    sleep 5 3>- &
    echo 'forked'
}

@test "hanging check" {
    echo 'hang'
}


@test "fork something" {
   # (while true; do sleep 5 3>- ; done) &
    sleep 100 3>&- & 
    echo 'forked'
}

@test "hanging check" {
    echo 'hang'
}

@test[testA] "A pre-requisite check" {
  echo 'testA'
}


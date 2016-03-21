<?php
    



    
    $pass = $_POST['pass'];
    $name = $_POST['name'];

    //fetch table rows from mysql db
    $sql = "select * from User where name = '$name' AND password = '$pass'";
    $result = mysqli_query($connection, $sql) or die("Error in Selecting " . mysqli_error($connection));
    //create an array
    $user = array();
    while($row = mysqli_fetch_assoc($result))
    {
      $user = $row;
    }

    $test = array($name => 'name', $pass => 'password');
        // Finally, encode the array to JSON and output the results
    echo json_encode($user);
    // Close connections
    mysqli_close($con);
?>
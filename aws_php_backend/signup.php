<?php
    
    
    
    
    $pass = $_POST['pass'];
    $name = $_POST['name'];
    
    //fetch table rows from mysql db
    $sql = "INSERT INTO User (password, tutor, name) VALUES ('$pass','0','$name')";
    $result = mysqli_query($connection, $sql) or die("Error in Selecting " . mysqli_error($connection));

    if(mysqli_query($connection, $sql) == TRUE)
    {
        die('Failed Insert' . mysqli_error());

    }
    else
    {
      $array = array('username' => $name, 'password' => $pass);
      echo json_encode($array);
    }
    
    mysqli_close($con);
?>
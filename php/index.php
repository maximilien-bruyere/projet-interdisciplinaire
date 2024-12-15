<?php

session_start();

$email = null;
$password = null;
$erreurs = [];

if (isset($_POST['submit'])) {
    if (!empty($_POST['email'])) {
        $email = trim(strip_tags($_POST['email']));
    } else {
        $erreurs['email'] = true;
    }

    if (!empty($_POST['password'])) {
        $password = trim(strip_tags($_POST['password']));
    } else {
        $erreurs['password'] = true;
    }
}

$error_message = isset($_SESSION['error_message']) ? $_SESSION['error_message'] : null;
unset($_SESSION['error_message']);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion | bruyere-lab</title>
    <link href="./style.css" rel="stylesheet" />
</head>
<body>

<header></header>

<main>
    <form method="post" action="_auth.php">
        <p <?php if (isset($erreurs['email'])) echo 'class="red"'; ?>>
            <label for="login">Identifiant :<br>
                <input type="email" name="email" id="login">
            </label>
        </p>
        <p <?php if (isset($erreurs['password'])) echo 'class="red"'; ?>>
            <label for="password">Mot de passe :<br>
                <input type="password" name="password" id="password">
            </label>
        </p>
        <p><input type="submit" name="submit" value="Connexion"></p>
        <?php if ($error_message): ?>
            <p class="red"><?php echo htmlspecialchars($error_message); ?></p>
        <?php endif; ?>
    </form>
</main>

<footer></footer>

</body>
</html>
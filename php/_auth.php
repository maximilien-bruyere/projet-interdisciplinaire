<?php

session_start();

function authenticate_user($email, $password) {

    $ldap_host = "ldap://dc.bruyere-lab.com";
    $ldap_port = 389;
    $ldap_dn = "DC=bruyere-lab,DC=com";
    $admin_user = "CN=admin,OU=Administration,DC=bruyere-lab,DC=com";
    $admin_password = "Maximilien2004";

    // Connect to the LDAP server
    $ldap_conn = ldap_connect($ldap_host, $ldap_port);
    if (!$ldap_conn) {
        die("Unable to connect to the LDAP server");
    }

    ldap_set_option($ldap_conn, LDAP_OPT_PROTOCOL_VERSION, 3);
    ldap_set_option($ldap_conn, LDAP_OPT_REFERRALS, 0);

    $ldap_bind = ldap_bind($ldap_conn, $admin_user, $admin_password);
    if (!$ldap_bind) {
        die("LDAP authentication failed: " . ldap_error($ldap_conn));
    }

    $escaped_email = ldap_escape($email, "", LDAP_ESCAPE_FILTER);

    $search_filter = "(userPrincipalName=$escaped_email)";
    $search_base = $ldap_dn;
    $attributes = ["cn", "distinguishedName", "memberOf"];
    $search_result = ldap_search($ldap_conn, $search_base, $search_filter, $attributes);

    if (!$search_result) {
        die("LDAP search failed: " . ldap_error($ldap_conn));
    }

    $entries = ldap_get_entries($ldap_conn, $search_result);

    if ($entries["count"] == 0) {
        $_SESSION['error_message'] = "Utilisateur non trouvé";
        header("Location: index.php");
        exit();
    }

    $user_dn = $entries[0]["distinguishedname"][0];
    $user_cn = $entries[0]["cn"][0];
    $user_groups = $entries[0]["memberof"];

    $user_bind = ldap_bind($ldap_conn, $user_dn, $password);
    if (!$user_bind) {
        die("Authentication failed for user $email: " . ldap_error($ldap_conn));
    }

    $role = "guest";

    $roles = [
        "administrator" => "CN=GG_Administration,OU=GG,OU=GROUPES,DC=bruyere-lab,DC=com",
        "moderator" => "CN=GG_Moderation,OU=GG,OU=GROUPES,DC=bruyere-lab,DC=com",
        "developer" => "CN=GG_Developpement,OU=GG,OU=GROUPES,DC=bruyere-lab,DC=com",
        "security" => "CN=GG_Securite,OU=GG,OU=GROUPES,DC=bruyere-lab,DC=com"
    ];

    foreach ($roles as $role_name => $group_dn) {
        if (in_array($group_dn, $user_groups)) {
            $role = $role_name;
            break;
        }
    }

    ldap_unbind($ldap_conn);

    return [
        "cn" => $user_cn,
        "role" => $role
    ];
}

$email = $_POST['email'];
$password = $_POST['password'];
$user_info = authenticate_user($email, $password);

// Stocker les informations de l'utilisateur dans la session
$_SESSION['user_info'] = $user_info;

// Rediriger vers la page de bienvenue
header("Location: welcome.php");
exit();
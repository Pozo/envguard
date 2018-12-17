package com.github.pozo

fun main(args: Array<String>) {
    val username: String? = System.getenv("MYSQL_USERNAME")
    val password: String? = System.getenv("MYSQL_PASSWORD")

    println("Hello, world $username with $password!")
}

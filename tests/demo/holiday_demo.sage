float wallet = 10
str greeting = "Welcome to the sage holiday excursion!"

def int main() {
    greet_travelor()
    while (wallet > 0) {
        store_1()
        store_2()
        store_3()
    }
}

def void greet_traveler() {
    str money_annmt = "You have 10 elf currency to spend!"
    prints( greeting + money_annmt)
}

def void store_greeting(str store_num) {
    prints("Welcome to store #" + store_num)
}

def void print_menu(str item1, float p1, str item2, float p2, str item3, float p3) {
    prints("Here is what we have to offer: ")

    prints("Item 1: " + item1 + "will cost this in elf currency")
    printfl(p1)

    prints("Item 2: " + item2 + "will cost this in elf currency")
    printfl(p2)

    prints("Item 3: " + item3 + "will cost this in elf currency")
    printfl(p3)
} 

def bool money_check(int coins, int price) {
    if (coins < price) {
        return False
    }
    else {
        return True
    }
}

def void store_experience(float p1, float p2, float p3, str i1,str i2,str i3) {
    print_menu(i1,p1,i2,p2,i3,p3)
    
    
    if (money_check(wallet, p1) == True) {
        prints("You can buy a(n) " + i1")
    }
    else {
        prints("You cannot buy a(n) " + i1")
    }

    if (money_check(wallet, p2) == True) {
        prints("You can buy a(n) " + i2")
    }
    else {
        prints("You cannot buy a(n) " + i1")
    }

    if (money_check(wallet, p3) == True) {
        prints("You can buy a(n) " + i3")
    }
    else{
        prints("You cannot buy a(n) " + i1")
    }
}
def void store_1() {
    store_greeting("1")
    int p1 = 5.20
    int p2 = 6.30
    int p3 = 12.66

    str item1 = "ornament"
    str item2 = "mini tree"
    str item3 = "santa costume"
    
    store_experience(p1,p2,p3,item1,item2,item3)

    prints("Nothing was purchased here. Onto the next store!")

}

def void store_2() {
    store_greeting("2")
    int p1 = 12.24
    int p2 = 62.32
    int p3 = 122.99

    str item1 = "mittens"
    str item2 = "fancy scarf"
    str item3 = "new boots"
    
    store_experience(p1,p2,p3,item1,item2,item3)

    prints("Nothing was purchased here. Onto the next store!")
}

def void store_3() {
    store_greeting("3")
    int p1 = 0.24
    int p2 = 0.32
    int p3 = 0.99

    str item1 = "lollipop"
    str item2 = "twizzlers"
    str item3 = "dark chocolate"
    
    store_experience(p1,p2,p3,item1,item2,item3)

    int i= 0;
    int item1_cnt = 0;
    int item2_cnt = 0;
    int item3_cnt = 0;

    for (i; i < 10; i = i + 1) {
        wallet = wallet - p1
        item1_cnt = item1_cnt + 1
    }

    for (i; i < 10; i = i + 1) {
        wallet = wallet - p2
        item2_cnt = item2_cnt + 1
    }

    for (i; i < 10; i = i + 1) {
        wallet = wallet - p3
        item3_cnt = item3_cnt + 1
    }
    prints("You have purchased ")
    printi(item1_cnt)
    prints(item1 + "s")

    prints("You have purchased ")
    printi(item2_cnt)
    prints(item2 + "s")

    prints("You have purchased ")
    printi(item3_cnt)
    prints(item3 + "s")

    prints("You have ")
    printi(wallet)
    prints(" elf currency left. Come back soon!")
}


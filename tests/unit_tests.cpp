// Юніт-тести для math_operations.h, використовуючи Google Test
// Тести: додавання двох позитивних чисел, додавання від'ємних чисел,
// додавання нуля, додавання великого числа.

#include <gtest/gtest.h>
#include "math_operations.h"
#include <limits>

TEST(AdditionTests, PositiveNumbers) {
    EXPECT_EQ(add(2, 3), 5);
    EXPECT_EQ(add(10, 20), 30);
}

TEST(AdditionTests, NegativeNumbers) {
    EXPECT_EQ(add(-2, -3), -5);
    EXPECT_EQ(add(-10, -20), -30);
}

TEST(AdditionTests, Zero) {
    EXPECT_EQ(add(0, 5), 5);
    EXPECT_EQ(add(0, 0), 0);
    EXPECT_EQ(add(5, 0), 5);
}

TEST(AdditionTests, LargeNumbers) {
    // великі, але не переповнюючі значення
    EXPECT_EQ(add(1000000000, 1000000000), 2000000000);
    EXPECT_EQ(add(std::numeric_limits<int>::max() - 1, 0), std::numeric_limits<int>::max() - 1);
}

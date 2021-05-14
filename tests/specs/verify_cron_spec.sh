#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034

for f in "$APP_PATH"/common/*; do . "$f"; done
for f in "$APP_PATH"/entrypoint/*; do . "$f"; done

test__verify_cron__returns_true_on_5_star_cron() {
  test_begin "verify_cron returns true on 5 star cron"

  # Arrange
  test_cron="* * * * *"
  result=0

  # Act
  (verify_cron test_cron) && result=1

  # Assert
  assert_equals "1" "$result"
}

test__verify_cron__returns_true_on_divided_by_cron() {
  test_begin "verify_cron returns true on divided by cron"

  # Arrange
  test_cron="* */5 * * *"
  result=0

  # Act
  (verify_cron test_cron) && result=1

  # Assert
  assert_equals "1" "$result"
}

test__verify_cron__returns_true_on_ranged_cron() {
  test_begin "verify_cron returns true on ranged cron"

  # Arrange
  test_cron="* * 1-5 * *"
  result=0

  # Act
  (verify_cron test_cron) && result=1

  # Assert
  assert_equals "1" "$result"
}

test__verify_cron__returns_true_on_multiple_values_cron() {
  test_begin "verify_cron returns true on multiple values cron"

  # Arrange
  test_cron="* * 1,3,5 * *"
  result=0

  # Act
  (verify_cron test_cron) && result=1

  # Assert
  assert_equals "1" "$result"
}

test__verify_cron__returns_true_on_ranged_and_multiple_values_cron() {
  test_begin "verify_cron returns true on ranged and multiple values cron"

  # Arrange
  test_cron="* * 1-10,1,3,5 * *"
  result=0

  # Act
  (verify_cron test_cron) && result=1

  # Assert
  assert_equals "1" "$result"
}

test__verify_cron__returns_false_on_1_star_cron() {
  test_begin "verify_cron returns false on 1 star cron"

  # Arrange
  test_cron="*"
  result=0

  # Act
  (verify_cron test_cron) && result=1

  # Assert
  assert_equals "0" "$result"
}

test__verify_cron__returns_false_on_2_star_cron() {
  test_begin "verify_cron returns false on 2 star cron"

  # Arrange
  test_cron="* *"
  result=0

  # Act
  (verify_cron test_cron) && result=1

  # Assert
  assert_equals "0" "$result"
}

test__verify_cron__returns_false_on_3_star_cron() {
  test_begin "verify_cron returns false on 3 star cron"

  # Arrange
  test_cron="* * *"
  result=0

  # Act
  (verify_cron test_cron) && result=1

  # Assert
  assert_equals "0" "$result"
}

test__verify_cron__returns_false_on_4_star_cron() {
  test_begin "verify_cron returns false on 4 star cron"

  # Arrange
  test_cron="* * * *"
  result=0

  # Act
  (verify_cron test_cron) && result=1

  # Assert
  assert_equals "0" "$result"
}

test__verify_cron__returns_false_on_alphabetic_cron() {
  test_begin "verify_cron returns false on alphabetic cron"

  # Arrange
  test_cron="a * * * *"
  result=0

  # Act
  (verify_cron test_cron) && result=1

  # Assert
  assert_equals "0" "$result"
}

test__verify_cron__returns_false_on_wrong_ordered_cron() {
  test_begin "verify_cron returns false on wrong ordered cron"

  # Arrange
  test_cron="/*10 * * * *"
  result=0

  # Act
  (verify_cron test_cron) && result=1

  # Assert
  assert_equals "0" "$result"
}

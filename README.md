# OneTimePad

OneTimePad is a Ruby gem that provides a casually secure implementation of the One-Time Pad encryption technique. It uses multiple substitution ciphers and is suitable for educational and practical use.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'one_time_pad'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install one_time_pad
```

## Usage

Here's a basic example of how to use the OneTimePad class:

```ruby
require 'one_time_pad'

# Create a new OneTimePad instance
otp = OneTimePad.new

# Set a secret (optional, defaults to current time if not set)
otp.secret = Time.now

# Generate a one-time pad
pad = otp.generate_otp

# Encode a message
encoded_message = otp.code(message: "Hello, World!")

# Decode the message
decoded_message = otp.decode(message: encoded_message)

puts decoded_message # Output: Hello, World!
```

You can also initialize the OneTimePad with a secret or an existing pad:

```ruby
# Initialize with a secret
otp = OneTimePad.new(secret: Time.now)

# Initialize with an existing pad
existing_pad = Array.new(2048) { (32..126).to_a.shuffle }
otp = OneTimePad.new(otp: existing_pad)
```

Example using a custom number of rows:

```ruby
# Create a new OneTimePad instance
otp = OneTimePad.new

# Set the number of rows to 5
otp.rows = 5

# Generate a one-time pad
pad = otp.generate_otp

# Encode a message
encoded_message = otp.code(message: "This is a test message.")

# Decode the message
decoded_message = otp.decode(message: encoded_message)

puts decoded_message # Output: This is a test message.
```

## Features

- Generate a one-time pad based on a secret or current time
- Initialize with an existing pad
- Encode messages using ASCII characters (32-126)
- Decode messages using the same pad
- Handles non-ASCII characters by replacing them with underscores

## What is a Pad?

Its a matrix.  The columns are character values.  A row is a full collection of the ASCII characters (32..129)  You index a row using the value of the plaintext character minus 32.  `row[0]['x'.ord - 32` to get the encoded value for 'x'  Each row is used for encoding one character.  The next character to be incoded will be at the current row index + 1 with a module on the size of the Pad.

If we had a Pad size of 3 rows and wanted to encode the message 'xox'  The two 'x' characters would have the same encrypted value from row 0.  If the number of rows in the Pad is greater than the number of characters in your message then it is highly unlikely that the plaintext 'x' character would have the same encoded character since they never use the same row in the Pad.

## What is a Pad?

A Pad in this gem is a two-dimensional matrix used for encoding and decoding messages. It consists of multiple rows, each containing a shuffled set of ASCII characters (32-126).

```ruby
# Structure:
pad = [
  (32..126).to_a.shuffle,  # Row 0
  (32..126).to_a.shuffle,  # Row 1
  # ... more rows ...
]
```

Encoding process:
1. For each character in the plaintext:
   a. Calculate the index: char.ord - 32
   b. Use this index to look up the encoded value in the current row
   c. Move to the next row (wrapping around if necessary)

```ruby
# Example:
# To encode 'x' using row 0:
encoded_x = pad[0]['x'.ord - 32]
```

The Pad's size affects security:
- Larger Pads (more rows) reduce the chance of reusing rows for long messages
- A Pad with more rows than the message length ensures each character uses a unique substitution

Here is what happens when you have too few rows.

Example:
Encoding 'xox' with a 2-row Pad:
- 'x' uses row 0
- 'o' uses row 1
- 'x' uses row 0 (same as the first 'x')
- 'o' uses row 1 (same as the first 'o')

Now your secret hugs and kisses may be exposed.

The more rows approach significantly increases the difficulty of breaking the cipher through frequency analysis or other common cryptanalysis techniques.

## Background

The history of ciphers dates back thousands of years, with ancient examples such as the Caesar cipher, which shifted letters in the alphabet to obscure messages. Substitution ciphers, like the Caesar cipher, replace each letter of the plaintext with another letter. Although simple and historically significant, these early ciphers were vulnerable to frequency analysis due to their fixed substitution rules.

One of the most secure methods introduced in the 20th century is the One-Time Pad (OTP). The One-Time Pad was first conceptualized by Frank Miller in 1882 and was later popularized by Gilbert Vernam in 1917. It is the only cryptographic method recognized as information-theoretically secure when implemented correctly. The security of the OTP arises from its use of a completely random key that is as long as the message and used only once. This ensures that even with infinite computational power, an eavesdropper cannot decipher the message without the key.

However, while the One-Time Pad is theoretically unbreakable, it's crucial to emphasize that complexity does not inherently equate to strength. Despite the robust principles behind the One-Time Pad, practical implementation issues such as key generation and distribution can expose vulnerabilities.

In this OneTimePad Ruby gem, we harness the Ruby MT1995 pseudo-random number generator, which can produce approximately 4.3 billion possible seeds. This level of randomness is significant, but it is important to note that the true security of the implementation relies on the utilization of an unknown number of unique pads. We use a default pad size of 2048 rows, each containing shuffled ASCII codes from 32 to 126. This provides a significant amount of randomness for practical use.  Theoritically a plain text message could have 2048 "X" characters which result in 2048 unique encoded characters.

Each plaintext is run through different pads, adding layers of complexity. However, a determined adversary with sufficient resources and expertise might still find ways to break the cipher quickly.

This class aims to take advantage of these principles for educational and practical use, illustrating the foundational concepts of modern cryptography and the importance of careful implementation.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).



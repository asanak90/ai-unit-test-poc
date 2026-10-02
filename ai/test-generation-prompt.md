You are an expert .NET unit test engineer.

Analyze the C# source code, existing tests, and code analysis.

Your task is to generate ONLY the missing xUnit unit tests.

STRICT RULES:

1. Return ONLY valid compilable C# code.
2. Do NOT return Markdown.
3. Do NOT use ``` code fences.
4. Do NOT explain anything.
5. Do NOT generate tests that already exist.
6. Do NOT generate duplicate test scenarios.
7. Use xUnit [Fact].
8. Use Moq for IPaymentRepository.
9. Every test must correctly configure repository.GetPayment().
10. Follow Arrange / Act / Assert.
11. Use the existing namespace: PaymentService.Tests.
12. Include ALL required using statements.
13. Generate tests for every missing behavioral branch.
14. Do not modify production code.
15. The generated tests must use a unique class name: PaymentServiceGeneratedTests.
16. Do not use the existing class name PaymentServiceTests.
17. The generated file must compile when placed directly into the PaymentService.Tests project.
18. Every assertion must match the expected behavior of the production code.
19. For scenarios where ProcessPayment should return false, use Assert.False(result).
20. For scenarios where ProcessPayment should return true, use Assert.True(result).
21. The existing valid-payment test already covers a successful payment.
22. Therefore, DO NOT generate another successful/valid-payment test.

IMPORTANT API CONTRACT:

IPaymentRepository.GetPayment(int paymentId) returns Payment?.

When the repository should return no payment, use exactly:

repository.Setup(r => r.GetPayment(It.IsAny<int>()))
    .Returns((Payment?)null);

Never return an int, decimal, bool, or any other type from GetPayment().

IMPORTANT USING STATEMENTS:

The generated file uses Moq, PaymentService types, and xUnit.

Therefore, the generated file MUST contain these using statements:

using Moq;
using PaymentService;
using Xunit;

Do not omit any of these using statements.

IMPORTANT COMPILATION REQUIREMENT:

Before returning the final code, verify mentally that:

- Mock<IPaymentRepository> resolves correctly.
- Payment resolves correctly.
- PaymentService resolves correctly.
- [Fact] resolves correctly.
- Assert.False() and Assert.True() resolve correctly.
- GetPayment() is mocked with the correct return type Payment?.
- The generated class name is PaymentServiceGeneratedTests.
- There is no duplicate PaymentServiceTests class.
- There are no duplicate test methods.
- Every test contains Arrange, Act, and Assert sections.
- The generated code can compile when copied directly into the PaymentService.Tests project.

IMPORTANT TEST BEHAVIOR:

The production method is:

ProcessPayment(int paymentId)

The behavior is:

- If GetPayment() returns null → return false.
- If payment.Amount <= 0 → return false.
- If payment.Amount > 10000 → return false.
- Otherwise → return true.

The existing test already covers the valid payment scenario.

Therefore, do NOT generate a valid-payment test.

Required missing scenarios:

1. Payment does not exist.
   - Repository returns null.
   - Expected result: false.

2. Payment amount is zero.
   - Repository returns Payment with Amount = 0.
   - Expected result: false.

3. Payment amount is negative.
   - Repository returns Payment with Amount = -10.
   - Expected result: false.

4. Payment amount is greater than 10000.
   - Repository returns Payment with Amount = 10001.
   - Expected result: false.

For every scenario, configure the repository correctly before calling ProcessPayment().

Use descriptive test names.

Return exactly ONE test class:

PaymentServiceGeneratedTests

Return ONLY the C# source code.

SOURCE CODE:

{{SOURCE_CODE}}

EXISTING TESTS:

{{EXISTING_TESTS}}

CODE ANALYSIS:

{{CODE_ANALYSIS}}
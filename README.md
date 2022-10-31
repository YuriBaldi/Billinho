# Billinho

The Billinho project aims to simulate an API for managing the monthly fees paid by students to the educational institution they study.

1. Pull the project down from GitHub using `git clone`
2. Change into the project directory using `cd Billinho`
3. Install the gems using `bundle install`
4. Create the database `rake db:create`
5. Run the migrations `rake db:migrate`
6. Run `rspec` for test

You can use [Postman](https://www.postman.com/) to run the API only, however the project contains simple temporary screenshots for using the API.

## Entities

- [Institution](#institution)
- [Student](#student)
- [Enrollment](#enrollment)
- [Payment](#payment)

### Institution
| Field  | Type | Restrictions
| ------ | ---- | ------------
| Name   | Text | Cannot be empty and must be unique
| Cnpj   | Text | Must contain only numeric characters and must be unique
| Type   | Text | University, School or Nursey

### Student
| Field           | Type    | Restrictions
| --------------- | ------- | ------------
| Name            | Text    | Cannot be empty and must be unique
| Cpf             | Text    | Must contain only numeric characters, must be unique and cannot be empty
| Birth date      | Date    | University, School or Nursey
| Cell phone      | Integer |
| Gender          | Text    | Cannot be empty and must be m (male) or f (female)
| Payment method  | Text    | Cannot be empty and must be card or boleto

### Enrollment
| Field                | Type        | Restrictions
| -------------------- | ----------- | ------------
| Total course value   | Decimal     | Cannot be empty, > 0
| Quantity of payments | Integer     | Cannot be empty, >= 1
| Payment due day      | Integer     | Cannot be empty, >= 1, <= 31
| Course Name          | Text        | Cannot be empty
| Institution id       | Foreign key | Cannot be empty
| Student id           | Foreign key | Cannot be empty

### Payment
| Field                | Type        | Restrictions
| -------------------- | ----------- | ------------
| Payment value        | Decimal     | Cannot be empty
| Due date             | Date        | Cannot be empty
| Status               | Text        | Cannot be empty and must be open, paid or delayed
| Enrollment id        | Foreign key | Cannot be empty

## Basic actions in the API

- Listing and creation of an Educational Institution;
- Listing and creation of Students;
- Listing and creation of Enrollments;
- Invoice Listing.

Payments are created automatically after an invoice is created, and
- value = total course value / amount of invoices
- due date = date with due day of the one indicated in the enrollment, incrementing the months


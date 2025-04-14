#include <stdio.h>
#include <ctype.h>

int validate_alpha(const char *str)
{
    while (*str)
    {
        if (!isalpha(*str)) return 0;
        str++;
    }
    return 1;
}
int main()
{
    const char *input = "HelloWorld 1";
    if (validate_alpha(input))
    {
        printf("Cadena valida.\n");
    }
    else
    {
        printf("Cadena invalida.\n");
    }
    return 0;
}

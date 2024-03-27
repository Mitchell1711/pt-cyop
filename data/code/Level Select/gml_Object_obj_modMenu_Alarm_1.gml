var suff = ["", "_run", "_panic"];

for (var i = 0; i < 5; i ++)
{
    if (irandom(10) > 2)
        toppinSuffix[i] = suff[irandom(2)];
}
alarm[1] = 120;
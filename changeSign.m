function boolean = changeSign(currSign, changeSignThreshold)
    boolean = 0;
    if (rand(1)) > 0.5
        if currSign == -1 % no change
            return
        else
            if changeSignThreshold < rand(1)
                boolean = 1;
                return
            end
        end
    else
        if currSign == 1
            return
        else
            if changeSignThreshold < rand(1)
                boolean = 1;
                return
            end
            sign = 1;
        end
    end
end
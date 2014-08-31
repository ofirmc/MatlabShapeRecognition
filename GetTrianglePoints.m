function [ P1, P2, P3 ] = GetTrianglePoints( ExtremaPoints , shape)

    if(strcmp(shape, 'triangle'))

        X1 = ExtremaPoints(1, 1);
        Y1 = ExtremaPoints(1, 2);

        X2 = ExtremaPoints(2, 1);
        Y2 = ExtremaPoints(2, 2);
        temp1 = [X1, Y1];
        temp2 =  [X2, Y2];
        P1 = max(temp1, temp2);

        X1 = ExtremaPoints(3, 1);
        Y1 = ExtremaPoints(3, 2);

        X2 = ExtremaPoints(4, 1);
        Y2 = ExtremaPoints(4, 2);

         X3 = ExtremaPoints(5, 1);
         Y3 = ExtremaPoints(5, 2);
        temp1 = [X1, Y1];
        temp2 =  [X2, Y2];
        temp3 =  [X3, Y3];
        tmpForTwoPoints = max(temp1, temp2);
        P2 = max(tmpForTwoPoints, temp3);

        X1 = ExtremaPoints(6, 1);
        Y1 = ExtremaPoints(6, 2);

        X2 = ExtremaPoints(7, 1);
        Y2 = ExtremaPoints(7, 2);

        X3 = ExtremaPoints(8, 1);
        Y3 = ExtremaPoints(8, 2);
        temp1 = [X1, Y1];
        temp2 = [X2, Y2];
        temp3 = [X3, Y3];
        tmpForTwoPoints = max(temp1, temp2);
        P3 = max(tmpForTwoPoints, temp3);
    end
end
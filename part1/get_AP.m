function ap = get_AP(predict_label, labels_airplane)
    counter = 0;
    result = 0;
    for i = 1:size(predict_label,1)
         if predict_label(i) == labels_airplane(i) && predict_label(i) == 1 && labels_airplane(i) == 1
            counter = counter + 1; 
            result = result + (counter / i);
         else 
            x = 1; 
         end
    end
    ap = result * (1/50);
end
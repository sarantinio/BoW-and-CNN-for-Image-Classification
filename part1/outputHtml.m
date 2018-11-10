function outputHtml(ordered_images_airplane, ordered_images_cars, ordered_images_faces, ordered_images_motorbikes,ap_airplane, ap_cars, ap_faces, ap_motorbikes)
fid = fopen('testOutput.html','wt');
fprintf(fid, strcat('airplane_ap', num2str(ap_airplane)));
fprintf(fid, strcat('cars ap', num2str(ap_cars)));
fprintf(fid, strcat('faces ap', num2str(ap_faces)));
fprintf(fid, strcat('motorbikes ap', num2str(ap_motorbikes)));

for i = 1:size(ordered_images_airplane,2)
    text = strcat('<tr><td><img src="', ordered_images_airplane(i).folder, '/' , ordered_images_airplane(i).name,'"/></td><td><img src="',ordered_images_cars(i).folder, '/', ordered_images_cars(i).name ,'" /></td><td><img src="',ordered_images_faces(i).folder, '/', ordered_images_faces(i).name , '" /></td><td><img src="', ordered_images_motorbikes(i).folder , '/' , ordered_images_motorbikes(i).name ,'" /></td></tr>\n');
    fprintf(fid, text);    
end
fclose(fid); 
end
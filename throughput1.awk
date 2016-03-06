BEGIN {

          recvdSize = 0

           startTime = 400

           stopTime = 0

           pktsize = 0

     }

   

     {

                event = $1

                time = $2

                node_id = $3

                pkt_size = $8

                level = $4

                type = $7

  

     # Store start time

     if (level == "AGT" && event == "s" && type == "cbr") {

       if (time < startTime) {

                startTime = time

                }

          }

  

# Update total received packets' size and store packets arrival time

     if (level == "AGT" && event == "r" && type == "cbr") {

          if (time > stopTime) {

                stopTime = time

                }

          # Rip off the header

          hdr_size = pkt_size % pktsize

          pkt_size -= hdr_size

          # Store received packet's size

          recvdSize += pkt_size

         }

   }



    END {

         #printf("Average Throughput[kbps] = %.2f\t\t StartTime=%.2f\tStopTime=%.2f\n",(recvdSize/(stopTime-startTime))*(8/1000),startTime,stopTime)
         printf("%.2f\n",(recvdSize/(stopTime-startTime))*(8/1000))

    }



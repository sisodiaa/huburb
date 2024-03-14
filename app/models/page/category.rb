class Page::Category
  class << self
    def list
      {
        education: 'Tuitions, Crash Courses',
        food: 'Confectionary, Tiffins',
        medical: 'Clinics, Consultancy, Medicine shops',
        clothing: 'Tailors, Boutique, and Accessories',
        wellness: 'Yoga, Spa, Gym',
        grooming: 'Salon, Parlour',
        other: 'Other Categories'
      }
    end
  end
end
